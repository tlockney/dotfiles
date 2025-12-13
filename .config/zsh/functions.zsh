# Task capture function for Obsidian
task() {
  if [ $# -eq 0 ]; then
    echo "Usage: task <description> [#tags] [@priority]"
    return 1
  fi

  TASK_PATH="$HOME/Obsidian/Personal/Tasks/inbox.md"

  # Ensure the file exists
  if [ ! -f "$TASK_PATH" ]; then
    echo "Error: $TASK_PATH does not exist!"
    return 1
  fi

  # Add the task with timestamp
  echo "- [ ] $* <!-- $(date '+%Y-%m-%d %H:%M') -->" >> "$TASK_PATH"
  echo "✅ Added: $*"
}
