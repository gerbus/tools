#!/bin/zsh
# Two-way sync between ~/.slate and gerbus/tools (.slate at repo root).
# local changed only  -> commit + push
# remote changed only -> back up ~/.slate, then copy the repo version over it
# both changed        -> touch nothing, notify
export PATH="/opt/homebrew/bin:/usr/bin:/bin"
set -u

SRC="$HOME/.slate"
REPO="${SLATE_SYNC_REPO:-$HOME/Development/gerbus-tools}"
FILE=".slate"
STATE="$HOME/Library/Application Support/slate-sync/last-synced.sha"
BACKUPS="$HOME/Library/Application Support/slate-sync/backups"
NOTIFIED="$HOME/Library/Application Support/slate-sync/last-conflict"
LOCK="/tmp/slate-sync.lock"

log() { print -r -- "$(date '+%F %T') $*"; }
notify() { osascript -e "display notification \"$1\" with title \"slate-sync\"" >/dev/null 2>&1; }
sha() { shasum -a 256 "$1" | cut -d' ' -f1; }
# stash an uncommitted repo edit before it gets overwritten
save_dirty() {
  git diff --quiet HEAD -- "$FILE" && return
  mkdir -p "$BACKUPS"
  cp "$REPO/$FILE" "$BACKUPS/repo-uncommitted.$(date +%Y%m%d-%H%M%S)"
  log "backed up uncommitted $FILE edit from $REPO"
}

mkdir "$LOCK" 2>/dev/null || { log "another run in progress, skipping"; exit 0; }
trap 'rmdir "$LOCK"' EXIT

cd "$REPO" || { log "missing repo $REPO"; exit 1; }
git fetch -q origin master || { log "fetch failed"; exit 1; }
git merge -q --ff-only origin/master 2>/dev/null || { log "repo not fast-forwardable; needs manual attention"; notify "Repo needs manual attention"; exit 1; }

L=$(sha "$SRC")
R=$(git show "HEAD:$FILE" | shasum -a 256 | cut -d' ' -f1)  # committed version, ignoring uncommitted edits
B=$(cat "$STATE" 2>/dev/null || true)

if [[ -z "$B" ]]; then log "no baseline at $STATE; run setup first"; exit 1; fi

if [[ "$L" == "$R" ]]; then
  # a prior commit may not have been pushed yet (e.g. pre-push hook failed); retry before recording baseline
  if [[ -n "$(git rev-list origin/master..HEAD)" ]]; then
    git push -q --no-verify origin master || { log "push failed"; notify "slate-sync push failed (see log)"; exit 1; }
    log "pushed pending commit"
  fi
  [[ "$B" == "$L" ]] || print -r -- "$L" > "$STATE"
  rm -f "$NOTIFIED"
  exit 0
fi

if [[ "$R" == "$B" ]]; then
  save_dirty
  cp "$SRC" "$REPO/$FILE"
  git add "$FILE"
  git commit -q -m "chore: update .slate" || { log "commit failed"; exit 1; }
  git push -q --no-verify origin master || { log "push failed"; notify "slate-sync push failed (see log)"; exit 1; }
  print -r -- "$L" > "$STATE"
  log "pushed local changes"
elif [[ "$L" == "$B" ]]; then
  mkdir -p "$BACKUPS"
  cp "$SRC" "$BACKUPS/slate.$(date +%Y%m%d-%H%M%S)"
  save_dirty
  git show "HEAD:$FILE" > "$SRC"
  print -r -- "$R" > "$STATE"
  log "pulled remote changes into $SRC"
  notify "Pulled .slate updates from GitHub"
else
  log "CONFLICT: local and remote both changed since last sync; left both untouched"
  # notify once per distinct conflict, not every run
  if [[ "$(cat "$NOTIFIED" 2>/dev/null)" != "$L:$R" ]]; then
    notify "Conflict: ~/.slate and GitHub both changed"
    print -r -- "$L:$R" > "$NOTIFIED"
  fi
  exit 1
fi
