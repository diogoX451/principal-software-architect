#!/usr/bin/env bash
# Install principal-software-architect skill into local agent harnesses.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SKILL_SRC="$ROOT/skills/principal-software-architect"
AGENT_SRC="$ROOT/agents/principal-software-architect.md"

if [[ ! -f "$SKILL_SRC/SKILL.md" ]]; then
  echo "error: SKILL.md not found at $SKILL_SRC" >&2
  exit 1
fi

install_dir() {
  local dest="$1"
  mkdir -p "$(dirname "$dest")"
  rm -rf "$dest"
  mkdir -p "$dest"
  cp -R "$SKILL_SRC/." "$dest/"
  echo "installed skill → $dest"
}

# Claude Code / Cursor-style skills
if [[ -d "$HOME/.claude" ]] || [[ "${INSTALL_CLAUDE:-1}" == "1" ]]; then
  install_dir "$HOME/.claude/skills/principal-software-architect"
fi

# Grok
if [[ -d "$HOME/.grok" ]] || [[ "${INSTALL_GROK:-1}" == "1" ]]; then
  install_dir "$HOME/.grok/skills/principal-software-architect"
fi

# Codex (if skills dir exists or forced)
if [[ -d "$HOME/.codex" ]] || [[ "${INSTALL_CODEX:-0}" == "1" ]]; then
  install_dir "$HOME/.codex/skills/principal-software-architect"
fi

# Optional: Claude agent definition
if [[ -f "$AGENT_SRC" ]] && [[ -d "$HOME/.claude" ]]; then
  mkdir -p "$HOME/.claude/agents"
  cp "$AGENT_SRC" "$HOME/.claude/agents/principal-software-architect.md"
  echo "installed agent → $HOME/.claude/agents/principal-software-architect.md"
fi

echo
echo "Done. Invoke with:"
echo "  /principal-software-architect"
echo "  or ask for architecture review / system design / ADR"
