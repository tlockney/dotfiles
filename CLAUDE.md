# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

This is a dotfiles repository managed with YADM (Yet Another Dotfiles Manager).

## Commands

- No standard build/lint/test commands - this is a dotfiles repository
- Use `yadm status` to check status of tracked dotfiles
- Use `yadm add <file>` to track new dotfiles
- Use `yadm commit -m "message"` to commit changes
- Use `~/bin/tool-update` to update all installed tools

## Code Style

- Shell scripts: Use bash for scripts with proper error handling (set -e)
- Zsh configuration: Group related settings together with clear section headers
- Follow existing indentation (4 spaces in scripts, 2 spaces in config files)
- Use descriptive variable/function names (e.g., prepend_to_path)
- Add command explanation in comments for complex operations
- Check for command existence before using (e.g., `if type brew &>/dev/null`)
- Use platform-specific conditionals when needed (`if test $CURRENT_OS = "Darwin"`)
