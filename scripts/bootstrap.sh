#!/bin/sh
# Stable bootstrap: download the installer from the latest annotated release.
set -eu
repo=https://github.com/yinghuzhu/agent-delivery-playbook.git
tag=$(git ls-remote --tags "$repo" | awk '$2 ~ /refs\/tags\/[0-9]+\^\{\}$/ {name=$2; sub(/^refs\/tags\//,"",name); sub(/\^\{\}$/, "", name); if(length(name)==10) print name}' | LC_ALL=C sort -r | head -n 1)
[ -n "$tag" ] || { echo 'No published release found' >&2; exit 1; }
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT HUP INT TERM
curl -fsSL "https://raw.githubusercontent.com/yinghuzhu/agent-delivery-playbook/$tag/scripts/install.sh" -o "$work/install.sh"
sh "$work/install.sh" "$@"
