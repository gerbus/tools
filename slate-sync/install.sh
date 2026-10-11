#!/bin/zsh
# Install the two-way ~/.slate <-> GitHub sync on this machine.
# Run from a clone of gerbus/tools:  ./slate-sync/install.sh
set -eu

HERE="${0:A:h}"
REPO="${HERE:h}"
LABEL="com.gerbus.slate-sync"
PLIST="$HOME/Library/LaunchAgents/$LABEL.plist"
STATE_DIR="$HOME/Library/Application Support/slate-sync"

if [[ -e "$HOME/.slate" ]] && ! cmp -s "$HOME/.slate" "$REPO/.slate"; then
  print -u2 "~/.slate differs from $REPO/.slate."
  print -u2 "Reconcile them first (diff ~/.slate $REPO/.slate), then rerun."
  print -u2 "Installing now would treat your local file as a change and overwrite the repo copy."
  exit 1
fi
[[ -e "$HOME/.slate" ]] || cp "$REPO/.slate" "$HOME/.slate"

git -C "$REPO" config commit.gpgsign false   # unattended commits can't answer a signing prompt

mkdir -p "$HOME/bin" "$HOME/Library/LaunchAgents" "$HOME/Library/Logs" "$STATE_DIR"
cp "$HERE/sync-slate.sh" "$HOME/bin/sync-slate.sh"
chmod +x "$HOME/bin/sync-slate.sh"
sed "s|__HOME__|$HOME|g" "$HERE/com.gerbus.slate-sync.plist.template" > "$PLIST"
shasum -a 256 "$REPO/.slate" | cut -d' ' -f1 > "$STATE_DIR/last-synced.sha"

# SLATE_SYNC_REPO is read by the script; only needed if the clone isn't ~/Development/gerbus-tools
if [[ "$REPO" != "$HOME/Development/gerbus-tools" ]]; then
  print -u2 "Note: clone is not at ~/Development/gerbus-tools. Add SLATE_SYNC_REPO=$REPO to the plist's EnvironmentVariables."
fi

launchctl bootout "gui/$(id -u)/$LABEL" 2>/dev/null || true
launchctl bootstrap "gui/$(id -u)" "$PLIST"
print "Installed. Log: ~/Library/Logs/slate-sync.log"
