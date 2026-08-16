# Early shell initialization — MUST be sourced before any other module
# (first line in the .zshrc module list). Anything sourced before a tool's
# init line runs a second time inside its pty-proxy, so this module exists
# for tools that need to initialize before the bulk of shell config.
#
# Atuin pty-proxy starts wherever `atuin init` sits; everything sourced
# before that line runs twice inside the proxy (harmless, but costs startup
# time). Keep this module first so the heavy modules (brew shellenv,
# compinit, mise, tools) run exactly once, inside the proxy.

# Atuin shell history — standalone installs get their PATH here;
# Homebrew is already on PATH via .zshenv.
[[ -d "$HOME/.atuin/bin" ]] && case ":$PATH:" in
  *":$HOME/.atuin/bin:"*) ;;  # already in PATH
  *) PATH="$HOME/.atuin/bin:$PATH" ;;
esac
command -v atuin >/dev/null 2>&1 && eval "$(atuin init zsh)"
