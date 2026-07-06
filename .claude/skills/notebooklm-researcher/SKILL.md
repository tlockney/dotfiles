---
name: notebooklm-researcher
description: >
  Deep research workflow using the NotebookLM CLI. Manages the full research lifecycle:
  create research notebooks, gather sources (URLs, YouTube, PDFs, web research),
  analyze and synthesize content, generate outputs (reports, study guides, podcasts,
  mind maps, quizzes, slide decks, videos), and organize results locally.
  Use this skill whenever the user wants to research a topic, summarize videos or podcasts,
  create educational content, build a knowledge base, generate a topic survey, produce
  a quick-start tutorial, or any task involving NotebookLM — even if they don't mention
  it by name. Triggers on phrases like "research X", "summarize this video",
  "create a podcast about", "make flashcards for", "deep dive into", "survey the landscape of",
  "what does the literature say about", or "I need to learn about X quickly".
---

# NotebookLM Researcher

Orchestrate deep research workflows using the `nlm` CLI (from the
`notebooklm-mcp-cli` package). This skill manages the full lifecycle from topic
scoping through source gathering, analysis, content generation, and organized
local output.

For CLI command details, read `references/cli-reference.md` in this skill's directory.
The CLI also self-documents: `nlm --ai` prints its own AI-assistant guide, and
`nlm <command> --help` is authoritative for flags.

## Before You Start

Verify the CLI is ready:

```bash
nlm login --check
```

If auth has expired, tell the user to run `nlm login` — it opens a browser and
extracts cookies automatically. The CLI auto-recovers from most auth and
transient server errors (token refresh, headless re-auth, retries with
backoff), so only re-login when a command explicitly reports expired cookies.

**There is no "active notebook" context.** Every command takes a notebook ID
as an argument. For a multi-step session, set an alias once and use it
everywhere:

```bash
nlm alias list                    # check existing aliases first
nlm alias set rust-async <notebook_id>
nlm source list rust-async
```

**Generation and delete commands prompt for confirmation.** Always pass
`--confirm` (or `-y`) so commands don't block. For deletes, get the user's
explicit OK first — deletions are irreversible.

## Output Organization

All downloaded outputs go into a structured directory tree. The user can override
the destination, but the default is:

```
~/Documents/notebooklm/<notebook-slug>/
├── sources/          # Downloaded source texts (raw content exports)
├── reports/          # Briefing docs, study guides, blog posts
├── audio/            # Podcast/audio overviews
├── video/            # Video overviews
├── slides/           # Slide decks (PDF/PPTX)
├── diagrams/         # Mind maps, infographics
├── data/             # Data tables (CSV), quiz/flashcard exports
└── notes/            # Saved conversation Q&A, research notes
```

The `<notebook-slug>` is a kebab-case version of the notebook title
(e.g., "Research: Rust Async" becomes `research-rust-async`).

If the user specifies a different output location, use that instead.
If they ask for output "here" or "in this directory", use `./` as the base.

Create directories as needed when downloading — don't create the whole tree upfront.

## Research Lifecycle

Every research task follows this general arc. Not every step is needed every time —
adapt based on what the user asks for. A request to "summarize this YouTube video"
might only need steps 1-3 and a quick report, while "survey the landscape of
WebAssembly runtimes" needs the full cycle.

### 1. Scope the Research

Before creating anything, understand what the user needs:

- **Topic and angle** — "Rust async" is broad; "comparing Tokio vs async-std for HTTP servers" is actionable
- **Depth** — Quick overview? Comprehensive survey? Deep technical analysis?
- **Output format** — Report? Podcast? Slide deck? Multiple?
- **Audience** — Who is this for? Beginners? Experts? Stakeholders?

If the user's request is clear enough, don't over-interview — just proceed.
If it's vague ("research AI agents"), ask one focused question to narrow the angle.

### 2. Set Up the Notebook

Create a notebook with a descriptive title that captures the topic and angle.
Good titles make notebooks findable later.

```bash
nlm notebook create "Research: Comparing Rust Async Runtimes" --json
```

Capture the notebook ID from JSON output. For anything beyond a one-shot
command, set an alias (after checking `nlm alias list` for conflicts):

```bash
nlm alias set rust-async <notebook_id>
```

### 3. Gather Sources

This is where research quality is won or lost. The right sources determine
everything downstream — a notebook full of shallow blog posts produces shallow
outputs; authoritative, diverse sources produce insightful ones.

**Source strategy by research depth:**

| Depth | Approach | Source Count |
|-------|----------|-------------|
| Quick overview | 2-5 hand-picked URLs or a single video | 2-5 |
| Topic survey | Fast research + curated additions | 8-15 |
| Deep analysis | Deep research + targeted URLs + papers | 15-30 |

**Adding known sources** — When the user provides specific URLs, videos, or documents:

```bash
nlm source add <notebook_id> --url "https://..." --wait
nlm source add <notebook_id> --youtube "https://youtube.com/watch?v=..." --wait
nlm source add <notebook_id> --file ./document.pdf --wait
nlm source add <notebook_id> --text "inline content" --title "My Notes"
```

`--url` and `--youtube` are repeatable for bulk adds. The `--wait` flag blocks
until processing completes, which guarantees the source is queryable — use it
whenever you'll query or generate right after adding.

**Web research** — When the user wants broad topic coverage:

For quick results (~10 sources, ~30 seconds):
```bash
nlm research start "specific query" --notebook-id <notebook_id> --auto-import
```

For comprehensive coverage (~40-80 sources, ~5 minutes), run deep mode and
poll instead of blocking:

```bash
nlm research start "specific query" --notebook-id <notebook_id> --mode deep
# Note the task ID from the output, then:
nlm research status <notebook_id> --max-wait 900
nlm research import <notebook_id> <task_id>
```

`nlm research import` takes `--indices 0,2,5` to import a subset, or
`--cited-only` for just the sources the research summary actually cited.

**Research query tips:**
- Be specific. "Tokio vs async-std performance benchmarks 2026" beats "rust async"
- Run multiple targeted queries rather than one broad one
- Mix query angles: technical details, comparisons, tutorials, real-world usage
- Only one research task can be pending per notebook — import (or `--force`) before starting another

**After gathering:** Always verify sources are processed before moving on:

```bash
nlm source list <notebook_id> --json
```

All sources should show an enabled/ready status. If you added sources without
`--wait` and some are still processing, give them a moment and re-check.

### 4. Analyze and Explore

Use the chat interface to understand what you've gathered before generating outputs.
This step is about building understanding — both yours and the user's.

**Useful analysis patterns:**

```bash
# Get the lay of the land
nlm notebook query <notebook_id> "What are the main themes across all sources?"

# Find agreements and disagreements
nlm notebook query <notebook_id> "Where do the sources agree and disagree?"

# Extract structured information with source citations
nlm notebook query <notebook_id> "What are the key technical tradeoffs discussed?" --json

# Deep dive on specific sources only
nlm notebook query <notebook_id> "What about performance under load?" --source-ids <id1,id2>

# Multi-turn: reuse the conversation ID from a previous answer
nlm notebook query <notebook_id> "Expand on the second point" --conversation-id <cid>
```

Use `--json` when you need to trace claims back to specific sources — the
output includes citation references.

**Preserve key findings as notes.** There's no flag to save an answer
directly, so pipe important synthesis back in explicitly:

```bash
nlm note create <notebook_id> --title "Key Approaches" --content "..."
```

**For video/podcast sources:** After adding a YouTube URL or audio file as a source,
the full transcript is indexed. Ask targeted questions to extract the key content
rather than requesting a generic summary — you'll get better results.

### 5. Generate Outputs

Choose the right output type based on what the user needs. Often, generating
a report first gives you (and the user) a text-based foundation to review
before investing in richer formats like audio or video.

**Choosing the right output:**

| Need | Best Output | Why |
|------|------------|-----|
| Quick reference | Briefing doc | Concise, scannable, fastest to generate |
| Learning material | Study guide | Structured for retention, includes key concepts |
| Share with others | Blog post | Narrative format, accessible to wider audience |
| Tutorial content | Custom report | Full control over structure and focus |
| Visual overview | Mind map | Shows concept relationships at a glance |
| Presentation | Slide deck | Ready for meetings, supports presenter notes |
| Audio content | Podcast/audio | Deep-dive or brief format, good for commutes |
| Engagement/review | Quiz or flashcards | Tests understanding, good for study |

**Generating reports** (most reliable, start here when unsure):

```bash
# Briefing doc — executive summary style (default format)
nlm report create <notebook_id> --confirm

# Study guide — structured learning material
nlm report create <notebook_id> --format "Study Guide" --confirm

# Blog post — narrative style
nlm report create <notebook_id> --format "Blog Post" --confirm

# Custom — full control over structure, focus, and audience
nlm report create <notebook_id> --format "Create Your Own" --prompt "Write a quick-start tutorial covering setup, first project, and common pitfalls. Include code examples. Target audience: developers new to async programming." --confirm
```

The built-in formats take no extra instructions. When the user needs audience
targeting or structural control, use `"Create Your Own"` with a detailed
`--prompt` — that's where output quality is steered.

**Generating other content:**

```bash
# Mind map
nlm mindmap create <notebook_id> --confirm

# Podcast — steer with --focus
nlm audio create <notebook_id> --format deep_dive --focus "Practical tradeoffs. Assume the listener has built web services but hasn't used async Rust." --confirm
# Formats: deep_dive, brief, critique, debate; --length short|default|long

# Video explainer
nlm video create <notebook_id> --focus "Explain the core concepts visually, building from simple to complex" --confirm

# Quiz for review (difficulty is 1-5)
nlm quiz create <notebook_id> --count 10 --difficulty 3 --confirm

# Slide deck
nlm slides create <notebook_id> --confirm

# From specific sources only (any generation command)
nlm report create <notebook_id> --format "Study Guide" --source-ids <id1,id2> --confirm
```

**Polling for completion:** Generation is asynchronous. Audio/video takes
1-5+ minutes; reports and quizzes usually under a minute. Check artifact
status, grab the artifact ID, then download:

```bash
nlm studio status <notebook_id>          # list artifacts + status
nlm studio status <notebook_id> --json   # machine-readable
```

Wait until the artifact shows completed before downloading. Don't spin in a
tight loop — sleep 30-60s between polls for audio/video.

### 6. Download and Organize

Download completed artifacts into the output directory structure. Downloads
take the notebook ID and fetch the latest artifact of that type; pass
`--id <artifact_id>` to pick a specific one.

```bash
# Create output directory
mkdir -p ~/Documents/notebooklm/<notebook-slug>/reports

# Download
nlm download report <notebook_id> --output ~/Documents/notebooklm/<notebook-slug>/reports/briefing.md
nlm download audio <notebook_id> --output ~/Documents/notebooklm/<notebook-slug>/audio/overview.mp3
nlm download mind-map <notebook_id> --output ~/Documents/notebooklm/<notebook-slug>/diagrams/concepts.json
nlm download slide-deck <notebook_id> --format pptx --output ~/Documents/notebooklm/<notebook-slug>/slides/deck.pptx
```

Quiz and flashcard downloads take the artifact ID and support format
conversion (`--format json|markdown|html` — html is an interactive
self-contained page).

Always confirm with the user before downloading (it writes to the filesystem).

## Workflow Recipes

These are end-to-end patterns for common research tasks. Adapt as needed.

### Video/Podcast Summarization

When the user wants to understand a video or podcast:

1. Create notebook titled after the content (e.g., "Video: Rich Harris on Signals")
2. Add the YouTube URL or audio file as a source with `--wait`
3. Ask targeted questions to extract key points:
   - "What are the main arguments presented?"
   - "What concrete examples or demos are shown?"
   - "What are the key takeaways for practitioners?"
4. Generate a briefing doc to capture the summary
5. Download the report

For multiple related videos, add them all to one notebook — the analysis
will find connections across them.

### Topic Survey / Landscape Analysis

When the user wants to understand the current state of a field:

1. Create notebook with survey scope (e.g., "Survey: WebAssembly Runtimes 2026")
2. Run deep research with 2-3 targeted queries covering different angles
   (import each task's results before starting the next query)
3. Add any specific URLs the user cares about
4. Verify all sources are processed
5. Ask analytical questions:
   - "What are the main categories of approaches?"
   - "How do the major players compare?"
   - "What are the emerging trends?"
6. Save key findings as notes with `nlm note create`
7. Generate a study guide or briefing doc
8. Generate a mind map for visual overview
9. Download both to the output directory

### Quick-Start Tutorial Generation

When the user wants to create learning material:

1. Create notebook (e.g., "Tutorial: Getting Started with Deno")
2. Add official docs, good tutorials, and getting-started guides as sources
3. Wait for processing
4. Generate a custom report with tutorial-focused instructions:
   ```bash
   nlm report create <notebook_id> --format "Create Your Own" --prompt "Write a quick-start tutorial. Structure: Prerequisites, Installation, Hello World, First Real Project, Common Gotchas, Next Steps. Include code examples. Target audience: experienced developers new to this tool." --confirm
   ```
5. Download and review with the user

### Multi-Format Research Package

When the user needs comprehensive coverage of a topic in multiple formats:

1. Set up notebook and gather sources (survey workflow above)
2. Generate in this order (most reliable first):
   - Briefing doc (fast, gives you a text review)
   - Study guide (structured differently, catches different angles)
   - Mind map (visual complement)
   - Slide deck (if presentation needed)
   - Audio overview (if podcast needed — long generation time)
3. Poll `nlm studio status` and download each as it completes
4. Present the full package to the user

## Quality Guidance

**Source quality matters most.** Invest time in getting the right sources rather than
generating from mediocre ones. A notebook with 5 authoritative sources beats one
with 30 shallow ones.

**Steer output with the right knob per type.** Reports: `"Create Your Own"` +
`--prompt` for anything needing audience or structural control. Audio/video/quiz:
`--focus` with a concrete angle:
- `--focus "Practical implications, not theory"`
- `--focus "Include specific numbers and benchmarks where available"`
- `--focus "Audience: C-level executives, keep it non-technical"`

**Review before generating expensive outputs.** Generate a briefing doc or ask
a few questions before committing to audio/video generation (which takes minutes
and may hit rate limits — the CLI auto-retries transient errors). Make sure the
source material supports what the user wants.

**Save important chat answers as notes.** When you get a particularly good answer
from `nlm notebook query`, preserve it with `nlm note create`. These notes live
in the notebook alongside your research.

**For multi-source analysis**, ask questions that force cross-referencing:
"Where do sources disagree?" and "What does source X say that contradicts source Y?"
produce more insightful outputs than "Summarize everything."
