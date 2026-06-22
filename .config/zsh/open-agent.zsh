# open-agent — bridge remote SSH session back to the personal Mac.
# Managed as a standalone module; remove this file + its source line to undo.
case ":$PATH:" in
  *":$HOME/.local/bin:"*) ;;
  *) export PATH="$HOME/.local/bin:$PATH" ;;
esac
[[ -f "$HOME/.local/share/open-agent/open-agent-hook.sh" ]] && \
  source "$HOME/.local/share/open-agent/open-agent-hook.sh"
