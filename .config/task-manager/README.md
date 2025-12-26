# Task Manager

CLI and Alfred workflow for managing tasks in Notion.

## Setup

### 1. Notion Integration

1. Create an integration at [notion.so/my-integrations](https://www.notion.so/my-integrations)
2. Copy the "Internal Integration Secret" (starts with `ntn_`)
3. Share your Task Manager database with the integration

### 2. Store Token in 1Password

Store the Notion API token in 1Password. The default item name is "Notion API Token" with the token in a field labeled "credential".

To use a different item name, update `op_token_item` in `config.json`.

### 3. Configuration

Edit `config.json` in this directory:

```json
{
  "database_id": "your-database-id-here",
  "notion_url": "https://www.notion.so/your-database-url",
  "op_token_item": "Notion API Token"
}
```

The `database_id` is the 32-character ID from your database URL.

## Usage

### CLI

```bash
# Quick capture (most common)
task "Buy groceries"

# List active tasks (Ready + In Focus)
task-manager list

# List with filters
task-manager list ready      # Ready tasks only
task-manager list focus      # In Focus tasks only
task-manager list triage     # Triage tasks only
task-manager list all        # All non-complete tasks

# Complete a task
task-manager complete <task-id>

# Open database in browser (prints URL if in SSH session)
task-manager open
```

### Alfred

- `task <title>` - Quick capture a new task
- `tasks` - View active tasks (Ready + In Focus)
- `tasks all` - View all non-complete tasks
- `tasks ready` - View Ready tasks
- `tasks focus` - View In Focus tasks
- `tasks triage` - View Triage tasks
- `tasks open` - Open Notion database

**Actions on task list:**
- `Enter` - Complete the selected task
- `Cmd+Enter` - Open task in Notion

### Environment Variable Override

For shell use, you can set the token directly:

```bash
export NOTION_TOKEN="ntn_..."
task "My task"
```

This takes precedence over 1Password lookup.

## Conventions for Other Clients

When implementing task capture on other platforms (iOS Shortcuts, widgets, etc.), follow these conventions for consistency:

### Creating Tasks

**API Endpoint:** `POST https://api.notion.com/v1/pages`

**Required Headers:**
```
Authorization: Bearer <token>
Content-Type: application/json
Notion-Version: 2022-06-28
```

**Minimal Payload (quick capture):**
```json
{
  "parent": { "database_id": "<database_id>" },
  "properties": {
    "Title": {
      "title": [{ "text": { "content": "Task title here" } }]
    },
    "Status": {
      "status": { "name": "📥 Triage" }
    }
  }
}
```

### Default Values

| Field | Default | Notes |
|-------|---------|-------|
| Status | 📥 Triage | New tasks land here for processing |
| Context | (none) | Optional: "Work" or "Personal" |
| Energy/Interest | (none) | Optional |
| Time Estimate | (none) | Optional |
| Due Date | (none) | Optional |

### Status Values

| Key | Value | Group |
|-----|-------|-------|
| triage | 📥 Triage | To Do |
| ready | 🎯 Ready | To Do |
| waiting | ⏳ Waiting | To Do |
| focus | 🔥 In Focus | In Progress |
| complete | ✅ Complete | Complete |

### Context Values

- `Work` (blue)
- `Personal` (green)

### Energy/Interest Values

- `5 - Excited` (green)
- `4 - Interested` (blue)
- `3 - Neutral` (gray)
- `2 - Resistant` (yellow)
- `1 - Dreading` (red)

### Time Estimate Values

- `5 min` (green)
- `15 min` (green)
- `30 min` (yellow)
- `1 hour` (orange)
- `2+ hours` (red)

## Files

```
~/.config/task-manager/
├── config.json          # Configuration (database ID, 1Password item)
└── README.md            # This file

~/bin/
├── task-manager         # Main CLI script
└── task                 # Quick capture wrapper

~/.config/Alfred.alfredpreferences/workflows/
└── user.workflow.A1B2C3D4-.../
    ├── info.plist       # Workflow definition
    ├── task_add.sh      # Quick capture script
    ├── task_list.sh     # List tasks script
    └── task_complete.sh # Complete task script
```
