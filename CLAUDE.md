# CLAUDE.md

<overview>
This is a dotfiles repository managed with YADM (Yet Another Dotfiles Manager). This file provides guidance to Claude Code when working with configuration files and shell scripts in this repository.
</overview>

<context>
YADM is a dotfiles manager that uses git under the hood but provides additional features for managing configuration files across different systems. Unlike typical code repositories, dotfiles repos don't have standard build processes but focus on system configuration management.
</context>

<commands>
<primary>
- `yadm status` - Check status of tracked dotfiles
- `yadm add <file>` - Track new dotfiles
- `yadm commit -m "message"` - Commit changes
- `~/bin/tool-update` - Update all installed tools
</primary>

<note>
No standard build/lint/test commands exist - this is a configuration repository, not a build artifact.
</note>
</commands>

<conventions>
<shell_scripts>
- Use bash for scripts with proper error handling (`set -e`)
- Use descriptive variable/function names (e.g., `prepend_to_path`)
- Add command explanations in comments for complex operations
- Check for command existence before using: `if type brew &>/dev/null`
- Use 4-space indentation
</shell_scripts>

<zsh_config>
- Group related settings together with clear section headers
- Use 2-space indentation
- Follow logical ordering (exports, then aliases, then functions)
</zsh_config>

<cross_platform>
- Use platform-specific conditionals when needed
- Example: `if test $CURRENT_OS = "Darwin"`
- Test commands exist before execution
- Provide fallbacks for missing tools
</cross_platform>
</conventions>

<guidelines>
<when condition="adding new dotfiles">
1. Test the configuration on a clean system first
2. Use `yadm add` to track the file
3. Include relevant documentation in comments
4. Consider cross-platform compatibility
</when>

<when condition="modifying shell scripts">
1. Maintain existing error handling patterns
2. Preserve backward compatibility where possible
3. Test on both macOS and Linux if applicable
4. Update this documentation if adding new conventions
</when>

<when condition="updating tools">
1. Use the provided `~/bin/tool-update` script
2. Verify tools work after updates
3. Document any breaking changes in commit messages
</when>
</guidelines>

<examples>
<proper_error_handling>
```bash
#!/bin/bash
set -e  # Exit on any error

if ! type brew &>/dev/null; then
	echo "Homebrew not found, skipping brew operations"
	exit 0
fi
```
</proper_error_handling>

<cross_platform_check>
```bash
if test $CURRENT_OS = "Darwin"; then
	# macOS-specific operations
	export PATH="/opt/homebrew/bin:$PATH"
else
	# Linux-specific operations
	export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
fi
```
</cross_platform_check>
</examples>
