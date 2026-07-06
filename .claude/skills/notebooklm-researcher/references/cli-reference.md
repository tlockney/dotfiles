# NotebookLM CLI Reference

Command reference for `nlm` (the `notebooklm-mcp-cli` package, v0.8.x).
Source: https://github.com/jacob-bd/notebooklm-mcp-cli

`nlm --help` and `nlm <command> --help` are authoritative. `nlm --ai` prints
the CLI's own AI-assistant guide, but it can describe commands newer than the
installed version — trust `--help` when they disagree.

The CLI supports both noun-first (`nlm notebook create`) and verb-first
(`nlm create notebook`) styles. This reference uses noun-first throughout.

## Table of Contents

- [Authentication](#authentication)
- [Notebooks](#notebooks)
- [Aliases](#aliases)
- [Sources](#sources)
- [Research](#research)
- [Chat / Query](#chat--query)
- [Notes](#notes)
- [Generation (Studio)](#generation-studio)
- [Artifact Status](#artifact-status)
- [Downloads](#downloads)
- [Export to Google Docs/Sheets](#export-to-google-docssheets)
- [Batch, Cross-Notebook, Pipelines, Tags](#batch-cross-notebook-pipelines-tags)
- [Configuration](#configuration)
- [Output Formats](#output-formats)
- [Error Handling](#error-handling)
- [Timing Expectations](#timing-expectations)

## Authentication

```bash
nlm login                  # Authenticate — opens browser, extracts cookies
nlm login --check          # Only check if current auth is valid
nlm login --profile work   # Named profile
nlm login profile          # Manage auth profiles (subcommand)
nlm doctor                 # Full diagnostics: install, auth, browser, tool configs
```

The CLI auto-recovers from most failures: refreshes CSRF/session tokens on
401s, reloads tokens updated by other sessions, attempts headless re-auth from
the saved browser profile, and retries transient server errors (429/5xx) up to
3 times with backoff. Only run `nlm login` when a command explicitly reports
expired cookies.

Config and profiles live in `~/.notebooklm-mcp-cli/`. `NOTEBOOKLM_HL` sets the
default BCP-47 language/locale for generation.

## Notebooks

```bash
nlm notebook list                       # List all notebooks
nlm notebook list --json                # JSON output
nlm notebook list --quiet               # IDs only (for piping)
nlm notebook list --title               # "ID: Title" format
nlm notebook create "Title" --json      # Create and capture ID
nlm notebook get <id>                   # Notebook details
nlm notebook describe <id>              # AI summary with topics
nlm notebook rename <id> "New Title"
nlm notebook delete <id> --confirm      # Destructive — ask the user first
```

There is **no active-notebook context** — every command takes a notebook ID
(or an alias, see below).

## Aliases

Memorable names for UUIDs, usable anywhere an ID is expected:

```bash
nlm alias list                 # ALWAYS check before creating
nlm alias set myproject <uuid> # Create/update (type auto-detected)
nlm alias get myproject        # Resolve to UUID
nlm alias delete myproject
```

## Sources

```bash
# Adding sources (flags, repeatable where noted)
nlm source add <nb> --url "https://example.com"            # URL (repeatable)
nlm source add <nb> --youtube "https://youtu.be/..."       # YouTube (repeatable)
nlm source add <nb> --file ./document.pdf                  # Local file upload
nlm source add <nb> --text "content" --title "My Notes"    # Inline text
nlm source add <nb> --drive <doc-id> --type slides         # Drive (doc|slides|sheets|pdf)
nlm source add <nb> --url "..." --wait                     # Block until processed
nlm source add <nb> --file doc.pdf --wait --wait-timeout 600

# Management
nlm source list <nb>                   # List sources
nlm source list <nb> --json            # JSON with status
nlm source list <nb> --quiet           # IDs only
nlm source get <source-id>             # Metadata
nlm source describe <source-id>        # AI summary + keywords
nlm source content <source-id>         # Raw indexed text
nlm source content <source-id> --output file.txt
nlm source rename <source-id> "New" --notebook <nb>
nlm source delete <source-id> --confirm
nlm source stale <nb>                  # Drive sources needing refresh
nlm source sync <nb> --confirm         # Sync all stale Drive sources
```

Supported file types: PDF, TXT, MD, DOCX, CSV, EPUB, audio (MP3/M4A/WAV/AAC/OGG/OPUS),
video (MP4), images (JPG/PNG/GIF/WEBP).

Use `--wait` when you'll query or generate right after adding — it guarantees
the source is ready.

## Research

Discover and import web (or Drive) sources:

```bash
# Start (needs a destination: existing notebook or new title)
nlm research start "query" --notebook-id <nb>              # Fast web (~30s, ~10 sources)
nlm research start "query" --notebook-id <nb> --mode deep  # Deep web (~5min, ~40-80 sources)
nlm research start "query" --title "New Research Notebook" # Create destination notebook
nlm research start "query" --notebook-id <nb> --source drive
nlm research start "query" --notebook-id <nb> --auto-import  # Wait + import in one shot
nlm research start "query" --notebook-id <nb> --force      # Override a pending task

# Monitor (polls until done)
nlm research status <nb>                   # Default max wait 5min
nlm research status <nb> --max-wait 900    # For deep mode
nlm research status <nb> --max-wait 0      # Single check, no blocking

# Import discovered sources
nlm research import <nb> <task-id>                 # Import all
nlm research import <nb> <task-id> --indices 0,2,5 # Specific ones
nlm research import <nb> <task-id> --cited-only    # Only cited sources
```

Only one research task can be pending per notebook — import or `--force`
before starting another.

## Chat / Query

One-shot Q&A against notebook sources (persists to the web UI's chat history):

```bash
nlm notebook query <nb> "question"
nlm notebook query <nb> "question" --json                  # Includes citations
nlm notebook query <nb> "question" --source-ids <id1,id2>  # Specific sources
nlm notebook query <nb> "follow-up" --conversation-id <cid>
nlm notebook query <nb> "question" --timeout 180           # Default 120s

# Chat behavior (per notebook)
nlm chat configure <nb> --goal default|learning_guide|custom --prompt "..."
nlm chat configure <nb> --response-length longer|default|shorter
```

**Never run `nlm chat start`** — it opens an interactive REPL that agents
can't control. Use `nlm notebook query` instead.

## Notes

```bash
nlm note list <nb>
nlm note create <nb> --content "..." --title "Title"   # --content is required
nlm note update <nb> <note-id> --content "..." --title "..."
nlm note delete <nb> <note-id>
```

There's no flag to save a query answer as a note directly — pipe the answer
into `nlm note create` yourself.

## Generation (Studio)

All generation commands take the notebook ID first and support:
`--confirm`/`-y` (skip prompt — required for automation),
`--source-ids <id1,id2>`, `--language <bcp-47>`, `--profile <name>`.

| Type | Command | Key Options |
|------|---------|-------------|
| Podcast | `nlm audio create <nb>` | `--format deep_dive\|brief\|critique\|debate`, `--length short\|default\|long`, `--focus "topic"` |
| Video | `nlm video create <nb>` | `--format explainer\|brief\|cinematic\|short`, `--style auto_select\|classic\|whiteboard\|kawaii\|anime\|watercolor\|retro_print\|heritage\|paper_craft`, `--focus "direction"` |
| Report | `nlm report create <nb>` | `--format "Briefing Doc"\|"Study Guide"\|"Blog Post"\|"Create Your Own"`, `--prompt "..."` (required for Create Your Own) |
| Mind map | `nlm mindmap create <nb>` | `--title "..."` |
| Quiz | `nlm quiz create <nb>` | `--count N` (default 2), `--difficulty 1-5` (default 2), `--focus "..."` |
| Flashcards | `nlm flashcards create <nb>` | `--difficulty easy\|medium\|hard` |
| Slides | `nlm slides create <nb>` | `--format detailed_deck\|presenter_slides`, `--length short\|default` |
| Slide revision | `nlm slides revise <artifact-id>` | `--slide '<N> <instruction>'` (repeatable; creates a new deck) |
| Infographic | `nlm infographic create <nb>` | `--orientation landscape\|portrait\|square`, `--detail concise\|standard\|detailed` |
| Data table | `nlm data-table create <nb> "description"` | Description argument is required |

Notes:
- Report format names are quoted strings ("Study Guide"), not slugs.
- Built-in report formats take no extra instructions — use
  `--format "Create Your Own" --prompt "..."` for custom structure/audience.
- Audio accent follows the BCP-47 region subtag (`es-419` vs `es-ES`);
  prompt text does not reliably override it.
- Video `short` format is vertical ~60s, English-only, no `--style`.

## Artifact Status

Generation is asynchronous. Poll before downloading:

```bash
nlm studio status <nb>              # All artifacts + status
nlm studio status <nb> --json       # Machine-readable
nlm studio status <nb> --full       # All details
nlm studio delete <nb> <artifact-id> --confirm
```

Wait for "completed" and note the artifact ID. Sleep 30-60s between polls for
audio/video; don't spin.

## Downloads

Downloads take the notebook ID and fetch the **latest** artifact of that type
unless `--id <artifact-id>` is given. Use `--output`/`-o` for the path
(otherwise a default name like `<nb>_report.md` lands in the cwd).

```bash
nlm download audio <nb> --output podcast.mp3            # .mp3
nlm download video <nb> --output overview.mp4           # .mp4
nlm download report <nb> --output report.md             # .md/.txt
nlm download mind-map <nb> --output map.json            # .json
nlm download slide-deck <nb> --output deck.pdf          # .pdf (default)
nlm download slide-deck <nb> --format pptx -o deck.pptx # .pptx
nlm download infographic <nb> --output info.png         # .png
nlm download data-table <nb> --output data.csv          # .csv

# Quiz/flashcards take the artifact ID and convert formats
nlm download quiz <nb> <artifact-id> --format json|markdown|html
nlm download flashcards <nb> <artifact-id> --format json|markdown|html
```

`html` produces a self-contained interactive page with scoring.

## Export to Google Docs/Sheets

```bash
nlm export to-docs <nb> <artifact-id> --title "My Doc"   # Reports → Google Docs
nlm export to-sheets <nb> <artifact-id>                  # Data tables → Sheets
```

## Batch, Cross-Notebook, Pipelines, Tags

```bash
# Same operation across notebooks
nlm batch query "question" --notebooks "id1,id2"
nlm batch query "question" --tags "research"
nlm batch add-source "https://..." --notebooks "id1,id2"

# Aggregated answer with per-notebook citations
nlm cross query "Common themes?" --notebooks "id1,id2"

# Multi-step workflows (ingest→podcast, research→report, multi-format)
nlm pipeline list
nlm pipeline run ingest-and-podcast --notebook <nb> --input-url "https://..."
# Custom pipelines: YAML in ~/.notebooklm-mcp-cli/pipelines/

# Local tags for organization + batch targeting
nlm tag add <nb> --tags "ai,research"
nlm tag list
nlm tag select "ai research"     # Find relevant notebooks
```

## Configuration

```bash
nlm config show                # Current config (TOML; --json available)
nlm config get <key>
nlm config set <key> <value>
```

Keys: `auth.browser` (auto/chrome/arc/brave/edge/chromium/vivaldi/opera),
`auth.default_profile`, `output.format` (table/json), `output.color`,
`output.short_ids`.

## Output Formats

| Flag | Description | Available on |
|------|-------------|--------------|
| (none) | Rich table, compact — token-efficient default | all |
| `--json` / `-j` | Structured output for parsing | list, get, describe, query, status |
| `--quiet` / `-q` | IDs only, for piping | list commands |
| `--full` / `-a` | All columns/details | list, status |

When stdout is not a TTY (piping to `jq`), JSON is used automatically.
JSON query output includes citation references back to source IDs.

## Error Handling

| Error | Cause | Action |
|-------|-------|--------|
| "Cookies have expired" / "authentication may have expired" | Session expired | `nlm login` |
| "Notebook not found" | Wrong ID | `nlm notebook list` |
| "Source not found" | Wrong ID | `nlm source list <nb>` |
| Rate limit / 5xx | Google API flakiness | Auto-retried 3x with backoff; wait a few minutes if it still fails |
| "Research already in progress" | Pending task | Import it, or `--force` |
| Download fails | Generation incomplete | Check `nlm studio status <nb>` |
| Command hangs at a prompt | Missing `--confirm` | Add `--confirm`/`-y` to generation/delete commands |

## Timing Expectations

| Operation | Typical time |
|-----------|-------------|
| Source processing | 30s - a few min (use `--wait` on add) |
| Research (fast) | ~30s |
| Research (deep) | ~5 min (allow `--max-wait 900`) |
| Reports, quizzes, flashcards | 30-60s |
| Mind map, data table | under a minute |
| Audio generation | 1-5+ min |
| Video generation | several minutes |
