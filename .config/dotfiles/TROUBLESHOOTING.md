# Troubleshooting Tool Management

## "env: node: No such file or directory"

This error means mise-managed tools (node, python, etc.) aren't in your PATH.

### Diagnostic Steps

```bash
# 1. Check if mise is installed
which mise
mise --version

# 2. Check if tools are installed
mise list

# 3. Check what PATH mise thinks you should have
mise env | grep PATH

# 4. Check your current PATH
echo "$PATH" | tr ':' '\n' | grep mise
```

### Common Causes & Fixes

#### 1. Tools not installed yet

**Symptom**: `mise list` shows no tools or shows "not installed"

**Fix**:
```bash
# Install all tools from .mise.toml
mise install

# Or use the bootstrap/tool-update scripts
tool-update --tags mise,runtimes
```

#### 2. Mise not activated in shell

**Symptom**: `echo "$PATH"` doesn't show any `~/.local/share/mise/installs/` paths

**Fix**:
```bash
# Restart your shell
exec zsh

# Or manually source
source ~/.zshrc

# Verify mise is active
mise env
```

#### 3. Wrong directory context

**Symptom**: Works in some directories but not others

**Explanation**: Mise looks for `.mise.toml` in current directory and parent directories.

**Fix**: Ensure `.mise.toml` is in your home directory:
```bash
ls -la ~/.mise.toml
# If missing, pull latest dotfiles
```

#### 4. Circular dependency in PATH setup

**Symptom**: Shell hangs or PATH is corrupted

**Fix**: Comment out the `[env]` section in `.mise.toml` temporarily:
```toml
# [env]
# _.source = '''
# ...
# '''
```

Then restart shell and run `mise install`.

## "mise WARN missing: python@3.12.11"

This means Python isn't installed by mise yet.

### Fix

```bash
# Install missing tool
mise install python@3.12

# Or install all tools from .mise.toml
mise install
```

## Fresh Machine Setup

If you're setting up a new machine:

```bash
# 1. Clone dotfiles (if not using yadm)
git clone <your-repo> ~/dotfiles

# 2. Run bootstrap
~/dotfiles/bin/bootstrap

# 3. Restart shell
exec zsh

# 4. Verify
mise list
which node
which python
```

## Still Having Issues?

### Check mise configuration

```bash
# Show mise config
mise config

# Show mise environment
mise env

# Debug mode
MISE_DEBUG=1 mise doctor
```

### Check shell initialization order

```bash
# Trace what's being loaded
zsh -x -c 'source ~/.zshrc' 2>&1 | grep -E '(mise|PATH)'
```

### Reset mise completely

```bash
# Backup first!
mv ~/.local/share/mise ~/.local/share/mise.backup
mv ~/.local/bin/mise ~/.local/bin/mise.backup

# Reinstall
curl -fsSL https://mise.run | sh

# Reinstall tools
mise install
```
