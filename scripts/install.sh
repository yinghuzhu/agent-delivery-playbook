#!/bin/sh
set -eu
agent=shared
action=install
dest=
checkout=${XDG_DATA_HOME:-$HOME/.local/share}/agent-delivery-playbook
repo=https://github.com/yinghuzhu/agent-delivery-playbook.git
ref=
explicit_ref=false
source_dir=
while [ "$#" -gt 0 ]; do
 case "$1" in
 install|update) action=$1; shift ;;
 --agent|--dest|--checkout|--repo|--ref|--source)
  [ "$#" -ge 2 ] || exit 2
  case "$1" in
   --agent) agent=$2;; --dest) dest=$2;; --checkout) checkout=$2;;
   --repo) repo=$2;; --ref) ref=$2; explicit_ref=true;; --source) source_dir=$2;;
  esac
  shift 2;;
 --help|-h)
  echo 'Usage: install.sh [install|update] [--agent shared|codex|claude] [--dest DIR] [--checkout DIR] [--source LOCAL_REPO] [--repo URL] [--ref BRANCH_OR_TAG_OR_SHA]'
  exit 0;;
 *) echo 'Unknown argument' >&2; exit 2;;
 esac
done
case "$agent" in
 shared) default_dest=$HOME/.agents/skills;;
 codex) default_dest=${CODEX_HOME:-$HOME/.codex}/skills;;
 claude) default_dest=$HOME/.claude/skills;;
 *) echo 'Unsupported agent; select shared with --dest for other tools' >&2; exit 2;;
esac
[ -n "$dest" ] || dest=$default_dest
if [ -n "$source_dir" ]; then
 checkout=$source_dir
fi
latest_release() {
 git -C "$checkout" tag --list | LC_ALL=C sort -r | while IFS= read -r candidate; do
  case "$candidate" in
   *[!0-9]*|'') continue;;
  esac
  [ "${#candidate}" -eq 10 ] || continue
  [ "$(git -C "$checkout" cat-file -t "refs/tags/$candidate")" = tag ] || continue
  printf '%s\n' "$candidate"
  break
 done
}
if [ "$action" = update ]; then
 [ -d "$checkout/.git" ] || { echo 'Checkout not found' >&2; exit 1; }
 [ "$explicit_ref" = false ] || { echo 'Use a separate installation to change version channels' >&2; exit 1; }
 [ -z "$(git -C "$checkout" status --porcelain --untracked-files=all)" ] || { echo 'Local changes found; update stopped' >&2; exit 1; }
 channel=$(git -C "$checkout" config --local --get playbook.channel || true)
 old=$(git -C "$checkout" rev-parse HEAD)
 case "$channel" in
  release)
   git -C "$checkout" fetch origin --tags
   ref=$(latest_release)
   [ -n "$ref" ] || { echo 'No annotated release tag found' >&2; exit 1; }
   previous=$(git -C "$checkout" config --local --get playbook.version)
   [ "$ref" \> "$previous" ] || { echo "Already current: $previous ($old)"; exit 0; }
   git -C "$checkout" merge-base --is-ancestor HEAD "$ref^{commit}" || { echo 'Release history diverged; update stopped' >&2; exit 1; }
   git -C "$checkout" checkout --detach "$ref"
   git -C "$checkout" config --local playbook.version "$ref";;
  develop)
   [ "$(git -C "$checkout" symbolic-ref --quiet --short HEAD)" = develop ] || exit 1
   git -C "$checkout" pull --ff-only origin develop;;
  *) echo 'Pinned or unmanaged installation; automatic update disabled'; exit 0;;
 esac
 echo "Updated: $old -> $(git -C "$checkout" rev-parse HEAD)"
 echo 'Reload skills. User configuration was preserved.'
 exit 0
fi
if [ -z "$source_dir" ]; then
 if [ -e "$checkout" ]; then
  echo 'Checkout already exists; use --source to reuse it or update to refresh it' >&2; exit 1
 fi
 mkdir -p "$(dirname "$checkout")"
 git clone --no-checkout "$repo" "$checkout"
 if [ "$explicit_ref" = false ]; then
  ref=$(latest_release)
  [ -n "$ref" ] || { echo 'No annotated YYYYMMDDNN release tag found; no version installed' >&2; exit 1; }
  channel=release
 elif [ "$ref" = develop ]; then channel=develop
 else channel=pinned
 fi
 if [ "$channel" = develop ]; then
  git -C "$checkout" checkout -b develop --track origin/develop
 else git -C "$checkout" checkout --detach "$ref"
 fi
 git -C "$checkout" config --local playbook.channel "$channel"
 git -C "$checkout" config --local playbook.version "$ref"
 echo "Version: $ref ($(git -C "$checkout" rev-parse HEAD))"
fi
checkout=$(cd "$checkout" && pwd -P)
names='delivery-workflow acceptance-qa bug-record root-cause-investigation release-delivery'
for name in $names; do
 [ -f "$checkout/skills/$name/SKILL.md" ] || { echo "Missing skill: $name" >&2; exit 1; }
 if [ -e "$dest/$name" ] || [ -L "$dest/$name" ]; then
  if [ -L "$dest/$name" ] && [ "$(readlink "$dest/$name")" = "$checkout/skills/$name" ]; then :
  else echo "Existing entry: $name; no links changed" >&2; exit 1; fi
 fi
done
mkdir -p "$dest"
for name in $names; do
 if [ ! -L "$dest/$name" ]; then ln -s "$checkout/skills/$name" "$dest/$name"; fi
 echo "Linked: $name"
done
config_dir=${XDG_CONFIG_HOME:-$HOME/.config}/agent-playbook
mkdir -p "$config_dir"
if [ ! -e "$config_dir/agents.yaml" ]; then
 # noclobber preserves a configuration created concurrently.
 (set -C; cat "$checkout/skills/delivery-workflow/agents.yaml" > "$config_dir/agents.yaml")
fi
echo 'Installed. Edit user configuration, then reload skills. AGENTS.md was not installed.'
