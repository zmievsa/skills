#!/usr/bin/env bash
set -euo pipefail

repo_root="$(git -C "$(dirname "$0")" rev-parse --show-toplevel)"
manifest="$repo_root/public-skills.txt"

fail() {
  printf 'error: %s\n' "$1" >&2
  return 1
}

[[ -f "$manifest" ]] || fail "missing public-skills.txt"

skills=()
while IFS= read -r skill; do
  skills+=("$skill")
done < <(sed -e '/^[[:space:]]*$/d' -e '/^[[:space:]]*#/d' "$manifest")
(( ${#skills[@]} > 0 )) || fail "public-skills.txt contains no skills"

duplicates="$(printf '%s\n' "${skills[@]}" | sort | uniq -d)"
[[ -z "$duplicates" ]] || fail "duplicate skill names in public-skills.txt: $duplicates"

actual_skills="$(
  find "$repo_root/skills" -mindepth 1 -maxdepth 1 -type d -exec basename {} \; \
    | LC_ALL=C sort
)"
manifest_skills="$(printf '%s\n' "${skills[@]}" | LC_ALL=C sort)"
[[ "$actual_skills" == "$manifest_skills" ]] \
  || fail "skills/ directories do not match public-skills.txt"

for skill in "${skills[@]}"; do
  [[ "$skill" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]] \
    || fail "invalid skill name: $skill"

  skill_dir="$repo_root/skills/$skill"
  [[ -f "$skill_dir/SKILL.md" ]] || fail "missing skills/$skill/SKILL.md"

  declared_name="$(
    awk '
      NR == 1 && $0 == "---" { in_frontmatter = 1; next }
      in_frontmatter && $0 == "---" { exit }
      in_frontmatter && $1 == "name:" { sub(/^name:[[:space:]]*/, ""); print; exit }
    ' "$skill_dir/SKILL.md"
  )"
  [[ "$declared_name" == "$skill" ]] \
    || fail "skills/$skill declares name '$declared_name'"

  uvx --from skills-ref agentskills validate "$skill_dir"
done

symlinks="$(find "$repo_root" -path "$repo_root/.git" -prune -o -type l -print)"
[[ -z "$symlinks" ]] || fail "public repository must not contain symlinks: $symlinks"

unsafe_files="$(
  find "$repo_root" -path "$repo_root/.git" -prune -o -type f \
    \( -name '.env' -o -name '*.pem' -o -name '*.key' -o -name '*.p12' \) -print
)"
[[ -z "$unsafe_files" ]] || fail "unsafe file type in public repository: $unsafe_files"

secret_hits="$(
  rg -l --hidden --no-messages \
    --glob '!.git/**' \
    --glob '!**/scripts/validate.sh' \
    -e '-----BEGIN ([A-Z0-9 ]+ )?PRIVATE KEY-----' \
    -e 'sk-[A-Za-z0-9_-]{20,}' \
    -e '(gh[pousr]|xox[baprs])_[A-Za-z0-9_=-]{20,}' \
    -e 'AKIA[0-9A-Z]{16}' \
    -e 'AIza[0-9A-Za-z_-]{30,}' \
    -e 'zmievsa[@]gmail[.]com' \
    -e '/Users[/]zmievsa' \
    -e 'Grumpy[O]ats' \
    -e 'UAE Corporate[ ]Tax' \
    -e 'zsa_notification[_]bot' \
    -e 'codex[.]telegram[.]' \
    "$repo_root" || true
)"
[[ -z "$secret_hits" ]] || fail "possible private material found: $secret_hits"

printf 'Validated %d public skills.\n' "${#skills[@]}"
