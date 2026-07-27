# Atuin shell history — guard against missing binary
[ -f "$HOME/.atuin/bin/env" ] && . "$HOME/.atuin/bin/env"

# Guarded like the atuin line above: written by the uv/rustup installers, and
# absent on a machine that has not run them, where sourcing it unconditionally
# aborts the shell with status 127.
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"

# Cargo environment
# ~/.cargo is a symlink to /Volumes/Secondary which can hang in uninterruptible
# D-state I/O wait if the volume is unresponsive. Any filesystem operation on
# the symlink (stat, test, source) will block indefinitely. So we add the path
# directly without touching the filesystem. A non-existing path on PATH is
# harmless.
case ":$PATH:" in
  *":$HOME/.cargo/bin:"*) ;;  # already in PATH
  *) export PATH="$HOME/.cargo/bin:$PATH" ;;
esac
