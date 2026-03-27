# NotebookLM CLI Reference

Complete command reference for `notebooklm` CLI (v0.3.3).

## Table of Contents

- [Authentication](#authentication)
- [Notebooks](#notebooks)
- [Sources](#sources)
- [Research](#research)
- [Chat](#chat)
- [Notes](#notes)
- [Artifacts & Generation](#artifacts--generation)
- [Downloads](#downloads)
- [Configuration](#configuration)
- [Output Formats](#output-formats)
- [Error Handling](#error-handling)
- [Known Limitations](#known-limitations)

## Authentication

```bash
notebooklm login              # Opens browser for Google OAuth
notebooklm auth check          # Diagnose auth issues
notebooklm auth check --test   # Full validation with network test
notebooklm status              # Show current context and auth state
```

Environment variables for CI/CD and parallel agents:

| Variable | Purpose |
|----------|---------|
| `NOTEBOOKLM_HOME` | Custom config directory (default: `~/.notebooklm`) |
| `NOTEBOOKLM_AUTH_JSON` | Inline auth JSON — no file writes needed |

## Notebooks

```bash
notebooklm list                          # List all notebooks
notebooklm list --json                   # JSON output
notebooklm create "Title"               # Create notebook
notebooklm create "Title" --json        # Create and capture ID
notebooklm use <notebook_id>            # Set active notebook context
notebooklm status                        # Show active notebook
notebooklm clear                         # Clear notebook context
notebooklm rename <id> "New Title"      # Rename
notebooklm delete <id>                  # Delete (destructive)
notebooklm summary                       # AI-generated notebook insights
```

Partial IDs: Use first 6+ characters of UUIDs. Must be unique prefix.

## Sources

```bash
# Adding sources (type auto-detected)
notebooklm source add "https://example.com"              # URL
notebooklm source add "https://youtube.com/watch?v=..."  # YouTube
notebooklm source add ./document.pdf                     # File
notebooklm source add "Inline text content" --title "My Notes"  # Text

# Management
notebooklm source list                    # List all sources
notebooklm source list --json             # JSON output with status
notebooklm source get <source_id>         # Source details
notebooklm source fulltext <source_id>    # Full indexed text content
notebooklm source guide <source_id>       # AI-generated summary and keywords
notebooklm source rename <id> "New Name"  # Rename
notebooklm source delete <id>             # Delete
notebooklm source stale <id>              # Check if URL/Drive source needs refresh
notebooklm source refresh <id>            # Refresh a URL/Drive source

# Waiting for processing
notebooklm source wait <source_id>                    # Block until ready
notebooklm source wait <source_id> -n <notebook_id>   # With explicit notebook
notebooklm source wait <source_id> --timeout 120      # Custom timeout
```

Supported types: PDFs, YouTube URLs, web URLs, Google Docs/Drive, text files, Markdown, Word docs, audio files, video files, images.

Source limits by plan: Standard: 50, Plus: 100, Pro: 300, Ultra: 600 per notebook.

## Research

```bash
# Fast search (5-10 sources, seconds)
notebooklm source add-research "query"
notebooklm source add-research "query" --import-all

# Deep search (20+ sources, 2-5 minutes)
notebooklm source add-research "query" --mode deep --import-all
notebooklm source add-research "query" --mode deep --no-wait   # Non-blocking

# Google Drive search
notebooklm source add-research "query" --from drive

# Monitor deep research
notebooklm research status
notebooklm research wait --import-all
notebooklm research wait --import-all --timeout 300
```

## Chat

```bash
notebooklm ask "question"                                # Ask current notebook
notebooklm ask "question" --json                         # With source references
notebooklm ask "question" -s src_id1 -s src_id2          # Specific sources only
notebooklm ask "question" --save-as-note                 # Save answer as note
notebooklm ask "question" --save-as-note --note-title "Title"
notebooklm ask "question" -c <conversation_id>           # Continue conversation
notebooklm ask "question" -n <notebook_id>               # Explicit notebook

# Conversation history
notebooklm history                    # Show recent Q&A
notebooklm history --show-all         # Full content
notebooklm history --json             # JSON format
notebooklm history --save             # Save as note
notebooklm history --save --note-title "Summary"
notebooklm history --clear            # Clear local cache
```

JSON chat output includes `references` with `source_id`, `citation_number`, and `cited_text` for each citation.

## Notes

```bash
notebooklm note list                      # List all notes
notebooklm note create "Title" "Content"  # Create note
notebooklm note get <note_id>             # Read note
notebooklm note save <note_id> "New content"  # Update note
notebooklm note rename <note_id> "New Title"
notebooklm note delete <note_id>
```

## Artifacts & Generation

All generate commands support:
- `-s, --source` to limit to specific source(s)
- `--language` to override output language
- `--json` for machine-readable output (returns `task_id`)
- `--retry N` for automatic retry on rate limits
- `--wait / --no-wait` to control blocking behavior

| Type | Command | Key Options | Download Format |
|------|---------|-------------|-----------------|
| Podcast | `generate audio` | `--format [deep-dive\|brief\|critique\|debate]`, `--length [short\|default\|long]` | .mp3 |
| Video | `generate video` | `--format [explainer\|brief]`, `--style [auto\|classic\|whiteboard\|kawaii\|anime\|watercolor\|retro-print\|heritage\|paper-craft]` | .mp4 |
| Slide Deck | `generate slide-deck` | `--format [detailed\|presenter]`, `--length [default\|short]` | .pdf / .pptx |
| Slide Revision | `generate revise-slide "prompt" --artifact <id> --slide N` | `--wait` | *(re-download parent deck)* |
| Infographic | `generate infographic` | `--orientation [landscape\|portrait\|square]`, `--detail [concise\|standard\|detailed]` | .png |
| Report | `generate report` | `--format [briefing-doc\|study-guide\|blog-post\|custom]`, `--append "instructions"` | .md |
| Mind Map | `generate mind-map` | *(sync, instant)* | .json |
| Data Table | `generate data-table` | description required | .csv |
| Quiz | `generate quiz` | `--difficulty [easy\|medium\|hard]`, `--quantity [fewer\|standard\|more]` | .json/.md/.html |
| Flashcards | `generate flashcards` | `--difficulty [easy\|medium\|hard]`, `--quantity [fewer\|standard\|more]` | .json/.md/.html |

```bash
# Artifact management
notebooklm artifact list                        # List all artifacts
notebooklm artifact list --json                 # JSON with status
notebooklm artifact get <artifact_id>           # Details
notebooklm artifact wait <artifact_id>          # Block until done
notebooklm artifact wait <id> --timeout 600     # Custom timeout
notebooklm artifact poll <id>                   # Single status check
notebooklm artifact rename <id> "New Name"
notebooklm artifact delete <id>
notebooklm artifact suggestions                 # AI-suggested report topics
```

## Downloads

```bash
notebooklm download audio ./output.mp3
notebooklm download video ./output.mp4
notebooklm download slide-deck ./slides.pdf
notebooklm download slide-deck ./slides.pptx --format pptx
notebooklm download report ./report.md
notebooklm download mind-map ./map.json
notebooklm download data-table ./data.csv
notebooklm download quiz quiz.json
notebooklm download quiz --format markdown quiz.md
notebooklm download flashcards cards.json
notebooklm download flashcards --format markdown cards.md

# Batch download all of a type
notebooklm download <type> --all

# Explicit artifact/notebook for parallel safety
notebooklm download audio ./out.mp3 -a <artifact_id> -n <notebook_id>
```

## Configuration

```bash
# Chat persona
notebooklm configure --mode learning-guide
notebooklm configure --mode concise
notebooklm configure --mode detailed
notebooklm configure --persona "Act as a chemistry tutor"
notebooklm configure --response-length longer

# Language (global setting, affects all notebooks)
notebooklm language list          # 80+ supported languages
notebooklm language get           # Current setting
notebooklm language set ja        # Set globally
notebooklm language set zh_Hans --local  # Local only

# Sharing
notebooklm share status
notebooklm share public --enable
notebooklm share add "email@example.com"
notebooklm share view-level --level editor
```

## Output Formats

Commands with `--json` return structured data:

```json
// notebooklm create "Title" --json
{"id": "abc123de-...", "title": "Title"}

// notebooklm source add "url" --json
{"source_id": "def456...", "title": "...", "status": "processing"}

// notebooklm generate audio "..." --json
{"task_id": "xyz789...", "status": "pending"}

// notebooklm ask "question" --json
{"answer": "...", "conversation_id": "...", "turn_number": 1,
 "references": [{"source_id": "...", "citation_number": 1, "cited_text": "..."}]}
```

Status values:
- Sources: `processing` -> `ready` (or `error`)
- Artifacts: `pending` or `in_progress` -> `completed` (or `unknown`)

## Error Handling

| Error | Cause | Action |
|-------|-------|--------|
| Auth/cookie error | Session expired | `notebooklm auth check` then `notebooklm login` |
| "No notebook context" | Context not set | Use `-n <id>` or `notebooklm use <id>` |
| "No result found for RPC ID" | Rate limiting | Wait 5-10 min, retry |
| `GENERATION_FAILED` | Google rate limit | Wait and retry later |
| Download fails | Generation incomplete | Check `artifact list` for status |
| Invalid ID | Wrong ID | Run `notebooklm list` to verify |

Exit codes: 0 = success, 1 = error, 2 = timeout (wait commands only).

## Known Limitations

**Reliable operations** (always work): Notebooks, sources, chat, mind-map, report, data-table generation.

**May hit rate limits:** Audio, video, quiz, flashcard, infographic, slide deck generation. Retry after 5-10 minutes or use web UI as fallback.

**Processing times:**

| Operation | Typical Time | Suggested Timeout |
|-----------|-------------|-------------------|
| Source processing | 30s - 10 min | 600s |
| Research (fast) | 30s - 2 min | 180s |
| Research (deep) | 15 - 30+ min | 1800s |
| Notes, mind-map | instant | n/a |
| Quiz, flashcards | 5 - 15 min | 900s |
| Report, data-table | 5 - 15 min | 900s |
| Audio generation | 10 - 20 min | 1200s |
| Video generation | 15 - 45 min | 2700s |
