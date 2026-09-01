#!/usr/bin/env bash
#
# install-my-six-agents.sh — install one fixed six-agent Claude Code set into
# any repository.
#
# The set:
#   Mobile App Builder       engineering/engineering-mobile-app-builder.md
#   UI Designer              design/design-ui-designer.md
#   Product Manager          product/product-manager.md
#   Visual Storyteller       design/design-visual-storyteller.md
#   Performance Benchmarker  testing/testing-performance-benchmarker.md
#   Frontend Developer       engineering/engineering-frontend-developer.md
#
# Safety contract — this script:
#   * writes ONLY the six filenames listed above, and nothing else, ever
#   * never runs rm, never empties .claude/agents/, never touches any other
#     agent, config, or file already in the target repository
#   * prompts before replacing a file whose contents differ, and refuses to
#     overwrite silently when there is no terminal to prompt on
#   * verifies every installed file afterwards and exits non-zero if any of
#     the six is missing, malformed, or not byte-identical to its source
#
# Usage: ./scripts/install-my-six-agents.sh <target-repo-path> [options]
#
#   -y, --yes        replace differing files without prompting
#   -n, --dry-run    report what would happen; write nothing
#   -q, --quiet      suppress per-file progress (summary and errors still print)
#   -h, --help       this help
#
# Examples:
#   ./scripts/install-my-six-agents.sh ~/code/my-saas
#   ./scripts/install-my-six-agents.sh . --dry-run
#   ./scripts/install-my-six-agents.sh ~/code/my-app --yes
#
# Exit codes: 0 ok · 1 usage/target error · 2 verification failed · 3 declined
#
# No dependencies beyond bash 3.2 + coreutils, so it behaves the same on macOS
# and Linux.

set -euo pipefail

# --- the fixed set --------------------------------------------------------
# Parallel arrays (not an associative array) to stay bash 3.2 compatible.
AGENT_LABELS=(
  "Mobile App Builder"
  "UI Designer"
  "Product Manager"
  "Visual Storyteller"
  "Performance Benchmarker"
  "Frontend Developer"
)
AGENT_SOURCES=(
  "engineering/engineering-mobile-app-builder.md"
  "design/design-ui-designer.md"
  "product/product-manager.md"
  "design/design-visual-storyteller.md"
  "testing/testing-performance-benchmarker.md"
  "engineering/engineering-frontend-developer.md"
)
AGENT_COUNT=${#AGENT_SOURCES[@]}

# --- output ---------------------------------------------------------------
if [ -t 1 ] && [ -z "${NO_COLOR:-}" ]; then
  C_OK=$'\033[32m'; C_WARN=$'\033[33m'; C_ERR=$'\033[31m'
  C_DIM=$'\033[2m'; C_BOLD=$'\033[1m'; C_OFF=$'\033[0m'
else
  C_OK=""; C_WARN=""; C_ERR=""; C_DIM=""; C_BOLD=""; C_OFF=""
fi

QUIET=false
say()  { $QUIET || printf '%s\n' "$*"; }
ok()   { $QUIET || printf '  %s+%s %s\n' "$C_OK" "$C_OFF" "$*"; }
skip() { $QUIET || printf '  %s=%s %s\n' "$C_DIM" "$C_OFF" "$*"; }
warn() { printf '  %s!%s %s\n' "$C_WARN" "$C_OFF" "$*" >&2; }
err()  { printf '%serror:%s %s\n' "$C_ERR" "$C_OFF" "$*" >&2; }
usage() { sed -n '2,40p' "$0" | sed 's/^# \{0,1\}//'; }

# --- arguments ------------------------------------------------------------
TARGET=""
ASSUME_YES=false
DRY_RUN=false

while [ $# -gt 0 ]; do
  case "$1" in
    -y|--yes)     ASSUME_YES=true; shift ;;
    -n|--dry-run) DRY_RUN=true; shift ;;
    -q|--quiet)   QUIET=true; shift ;;
    -h|--help)    usage; exit 0 ;;
    -*)           err "unknown option: $1"; echo; usage >&2; exit 1 ;;
    *)
      if [ -n "$TARGET" ]; then
        err "unexpected extra argument: $1 (one target path only)"; exit 1
      fi
      TARGET="$1"; shift ;;
  esac
done

if [ -z "$TARGET" ]; then
  err "a target repository path is required"
  echo >&2
  usage >&2
  exit 1
fi

# --- resolve source (works no matter where the script is called from) -----
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SOURCE_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

missing_sources=""
i=0
while [ $i -lt "$AGENT_COUNT" ]; do
  [ -f "$SOURCE_ROOT/${AGENT_SOURCES[$i]}" ] || missing_sources="$missing_sources
    ${AGENT_SOURCES[$i]}"
  i=$((i + 1))
done
if [ -n "$missing_sources" ]; then
  err "source agent files not found under $SOURCE_ROOT:$missing_sources"
  err "run this script from a complete agency-agents checkout."
  exit 1
fi

# --- validate target ------------------------------------------------------
if [ ! -e "$TARGET" ]; then
  err "target path does not exist: $TARGET"
  err "create the directory first — this script will not create the repo itself."
  exit 1
fi
if [ ! -d "$TARGET" ]; then
  err "target is not a directory: $TARGET"
  exit 1
fi

TARGET_ROOT="$(cd "$TARGET" && pwd)"
DEST="$TARGET_ROOT/.claude/agents"

if [ ! -w "$TARGET_ROOT" ] && [ ! -d "$DEST" ]; then
  err "no write permission on $TARGET_ROOT"
  exit 1
fi

if [ ! -d "$TARGET_ROOT/.git" ]; then
  warn "$TARGET_ROOT is not a git repository root (installing anyway)"
fi

say ""
say "${C_BOLD}Installing 6 agents${C_OFF}"
say "  from  $SOURCE_ROOT"
say "  into  $DEST"
$DRY_RUN && say "  ${C_WARN}dry run — nothing will be written${C_OFF}"
say ""

# --- create destination (never removes an existing one) -------------------
if [ -d "$DEST" ]; then
  existing=$(find "$DEST" -maxdepth 1 -name '*.md' -type f 2>/dev/null | wc -l | tr -d ' ')
  say "  ${C_DIM}.claude/agents/ exists — $existing agent file(s) already there, all preserved${C_OFF}"
else
  if $DRY_RUN; then
    say "  ${C_DIM}would create $DEST${C_OFF}"
  else
    mkdir -p "$DEST"
    say "  ${C_DIM}created $DEST${C_OFF}"
  fi
fi
say ""

# --- prompt helper --------------------------------------------------------
# Reads from the terminal directly, so piping into the script still prompts.
# [ -r /dev/tty ] is not enough: the device node is readable even when the
# process has no controlling terminal to open, so probe with a real open.
tty_available() { ( exec 3< /dev/tty ) 2>/dev/null; }

ask_replace() {
  ask_file="$1"
  if $ASSUME_YES; then return 0; fi
  if ! tty_available; then
    warn "$ask_file differs but there is no terminal to ask on — left untouched"
    warn "    re-run with --yes to replace it"
    return 1
  fi
  printf '  %s?%s %s exists and differs. Replace it? [y/N] ' \
    "$C_WARN" "$C_OFF" "$ask_file" > /dev/tty
  read -r ask_reply < /dev/tty || ask_reply=""
  case "$ask_reply" in
    [yY]|[yY][eE][sS]) return 0 ;;
    *) return 1 ;;
  esac
}

# --- install --------------------------------------------------------------
n_new=0; n_same=0; n_replaced=0; n_kept=0
INSTALLED_NAMES=""

i=0
while [ $i -lt "$AGENT_COUNT" ]; do
  label="${AGENT_LABELS[$i]}"
  src="$SOURCE_ROOT/${AGENT_SOURCES[$i]}"
  base="$(basename "${AGENT_SOURCES[$i]}")"
  dst="$DEST/$base"
  INSTALLED_NAMES="$INSTALLED_NAMES $base"

  if [ -e "$dst" ]; then
    if cmp -s "$src" "$dst"; then
      skip "$label — already up to date ($base)"
      n_same=$((n_same + 1))
    elif $DRY_RUN; then
      say "  ${C_WARN}?${C_OFF} $label — differs, would prompt before replacing ($base)"
      n_replaced=$((n_replaced + 1))
    elif ask_replace "$base"; then
      cp "$src" "$dst"
      ok "$label — replaced ($base)"
      n_replaced=$((n_replaced + 1))
    else
      skip "$label — kept your version ($base)"
      n_kept=$((n_kept + 1))
    fi
  else
    if $DRY_RUN; then
      say "  ${C_OK}+${C_OFF} $label — would install ($base)"
    else
      cp "$src" "$dst"
      ok "$label — installed ($base)"
    fi
    n_new=$((n_new + 1))
  fi
  i=$((i + 1))
done

if $DRY_RUN; then
  say ""
  say "  Dry run: $n_new new, $n_replaced would prompt, $n_same already current."
  exit 0
fi

# --- verify ---------------------------------------------------------------
say ""
say "${C_BOLD}Verifying${C_OFF}"

failures=0
i=0
while [ $i -lt "$AGENT_COUNT" ]; do
  label="${AGENT_LABELS[$i]}"
  src="$SOURCE_ROOT/${AGENT_SOURCES[$i]}"
  base="$(basename "${AGENT_SOURCES[$i]}")"
  dst="$DEST/$base"
  problem=""

  if [ ! -f "$dst" ]; then
    problem="file missing"
  elif [ ! -s "$dst" ]; then
    problem="file is empty"
  elif [ "$(head -1 "$dst")" != "---" ]; then
    problem="no YAML frontmatter fence on line 1"
  elif ! grep -q '^name:[[:space:]]*[^[:space:]]' "$dst"; then
    problem="frontmatter has no name field"
  elif ! grep -q '^description:[[:space:]]*[^[:space:]]' "$dst"; then
    problem="frontmatter has no description field"
  elif ! cmp -s "$src" "$dst"; then
    # Not fatal: the user chose to keep their own edited copy.
    agent_name="$(grep -m1 '^name:' "$dst" | sed 's/^name:[[:space:]]*//')"
    warn "$label — loads OK as \"$agent_name\", but differs from the repo original (your copy kept)"
    i=$((i + 1))
    continue
  fi

  if [ -n "$problem" ]; then
    err "$label ($base): $problem"
    failures=$((failures + 1))
  else
    agent_name="$(grep -m1 '^name:' "$dst" | sed 's/^name:[[:space:]]*//')"
    ok "$label — loads as \"$agent_name\""
  fi
  i=$((i + 1))
done

say ""
if [ "$failures" -gt 0 ]; then
  err "$failures of $AGENT_COUNT agent(s) failed verification."
  exit 2
fi

total_now=$(find "$DEST" -maxdepth 1 -name '*.md' -type f | wc -l | tr -d ' ')
other=$((total_now - AGENT_COUNT))
say "${C_OK}All $AGENT_COUNT agents verified.${C_OFF}"
say "  $n_new installed · $n_replaced replaced · $n_same already current · $n_kept kept as yours"
if [ "$other" -gt 0 ]; then
  say "  $other other agent file(s) in $DEST left untouched"
fi
say ""
say "Start Claude Code in $TARGET_ROOT and invoke one by name, e.g.:"
say "  ${C_DIM}\"Activate Frontend Developer mode and scaffold the dashboard shell\"${C_OFF}"
say ""

if [ "$n_kept" -gt 0 ]; then
  exit 3
fi
exit 0
