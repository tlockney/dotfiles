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

Orchestrate deep research workflows using the `notebooklm` CLI. This skill manages
the full lifecycle from topic scoping through source gathering, analysis, content
generation, and organized local output.

For CLI command details, read `references/cli-reference.md` in this skill's directory.

## Before You Start

Verify the CLI is ready:

```bash
notebooklm status
```

If auth has expired, tell the user to run `notebooklm login` — it opens a browser.

## Output Organization

All downloaded outputs go into a structured directory tree. The user can override
the destination, but the default is:

```
~/Documents/notebooklm/<notebook-slug>/
├── sources/          # Downloaded source texts (fulltext exports)
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
notebooklm create "Research: Comparing Rust Async Runtimes" --json
```

Capture the notebook ID from JSON output and set context:

```bash
notebooklm use <notebook_id>
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
notebooklm source add "https://..." --json
notebooklm source add "https://youtube.com/watch?v=..." --json
notebooklm source add ./document.pdf --json
```

Add sources in sequence, capturing each source ID. After adding all sources,
wait for processing before proceeding to analysis or generation.

**Web research** — When the user wants broad topic coverage:

For quick results (5-10 sources, takes seconds):
```bash
notebooklm source add-research "specific query" --import-all
```

For comprehensive coverage (20+ sources, takes 2-5 minutes):
```bash
notebooklm source add-research "specific query" --mode deep --no-wait
```

Then monitor and import:
```bash
notebooklm research wait --import-all --timeout 300
```

**Research query tips:**
- Be specific. "Tokio vs async-std performance benchmarks 2025" beats "rust async"
- Run multiple targeted queries rather than one broad one
- Mix query angles: technical details, comparisons, tutorials, real-world usage

**After gathering:** Always verify sources are processed before moving on:

```bash
notebooklm source list --json
```

All sources should show `"status": "ready"`. If any are still processing,
wait for them with `notebooklm source wait <id>`.

### 4. Analyze and Explore

Use the chat interface to understand what you've gathered before generating outputs.
This step is about building understanding — both yours and the user's.

**Useful analysis patterns:**

```bash
# Get the lay of the land
notebooklm ask "What are the main themes across all sources?"

# Find agreements and disagreements
notebooklm ask "Where do the sources agree and disagree?"

# Extract structured information
notebooklm ask "What are the key technical tradeoffs discussed?" --json

# Deep dive on a specific aspect
notebooklm ask "What do the sources say about performance under load?" -s <relevant_source_id>

# Save important findings as notes for later reference
notebooklm ask "Summarize the three main approaches described" --save-as-note --note-title "Key Approaches"
```

Use `--json` when you need to trace claims back to specific sources.
Use `--save-as-note` to preserve key findings within the notebook.

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
# Briefing doc — executive summary style
notebooklm generate report --format briefing-doc --wait

# Study guide — structured learning material
notebooklm generate report --format study-guide --append "Target audience: developers new to async programming" --wait

# Blog post — narrative style
notebooklm generate report --format blog-post --wait

# Custom — full control
notebooklm generate report --format custom "Write a quick-start tutorial covering setup, first project, and common pitfalls. Include code examples." --wait
```

The `--append` flag is powerful for non-custom formats — it lets you add
specific instructions without losing the built-in format template.

**Generating other content:**

```bash
# Mind map (instant, synchronous)
notebooklm generate mind-map

# Podcast — describe the angle and audience
notebooklm generate audio "Focus on practical tradeoffs. Assume the listener has built web services but hasn't used async Rust."

# Video explainer
notebooklm generate video "Explain the core concepts visually, building from simple to complex"

# Quiz for review
notebooklm generate quiz --difficulty medium

# From specific sources only
notebooklm generate report --format study-guide -s <source_id_1> -s <source_id_2> --wait
```

**For long-running generation** (audio, video, slides): Use `--json` to capture the
artifact ID, then either poll manually or use a background task to wait:

```bash
notebooklm generate audio "..." --json
# Returns {"task_id": "...", "status": "pending"}

# Check later:
notebooklm artifact list
notebooklm artifact wait <artifact_id> --timeout 1200
```

### 6. Download and Organize

Download completed artifacts into the output directory structure:

```bash
# Create output directory
mkdir -p ~/Documents/notebooklm/<notebook-slug>/reports

# Download
notebooklm download report ~/Documents/notebooklm/<notebook-slug>/reports/briefing.md
notebooklm download audio ~/Documents/notebooklm/<notebook-slug>/audio/overview.mp3
notebooklm download mind-map ~/Documents/notebooklm/<notebook-slug>/diagrams/concepts.json
notebooklm download slide-deck ~/Documents/notebooklm/<notebook-slug>/slides/deck.pptx --format pptx
```

Always confirm with the user before downloading (it writes to the filesystem).

## Workflow Recipes

These are end-to-end patterns for common research tasks. Adapt as needed.

### Video/Podcast Summarization

When the user wants to understand a video or podcast:

1. Create notebook titled after the content (e.g., "Video: Rich Harris on Signals")
2. Add the YouTube URL or audio file as a source
3. Wait for processing
4. Ask targeted questions to extract key points:
   - "What are the main arguments presented?"
   - "What concrete examples or demos are shown?"
   - "What are the key takeaways for practitioners?"
5. Generate a briefing doc to capture the summary
6. Download the report

For multiple related videos, add them all to one notebook — the analysis
will find connections across them.

### Topic Survey / Landscape Analysis

When the user wants to understand the current state of a field:

1. Create notebook with survey scope (e.g., "Survey: WebAssembly Runtimes 2025")
2. Run deep research with 2-3 targeted queries covering different angles
3. Add any specific URLs the user cares about
4. Wait for all sources
5. Ask analytical questions:
   - "What are the main categories of approaches?"
   - "How do the major players compare?"
   - "What are the emerging trends?"
6. Save key findings as notes
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
   notebooklm generate report --format custom "Write a quick-start tutorial. Structure: Prerequisites, Installation, Hello World, First Real Project, Common Gotchas, Next Steps. Include code examples. Target audience: experienced developers new to this tool." --wait
   ```
5. Download and review with the user

### Multi-Format Research Package

When the user needs comprehensive coverage of a topic in multiple formats:

1. Set up notebook and gather sources (survey workflow above)
2. Generate in this order (most reliable first):
   - Briefing doc (fast, gives you a text review)
   - Study guide (structured differently, catches different angles)
   - Mind map (instant, visual complement)
   - Slide deck (if presentation needed)
   - Audio overview (if podcast needed — long generation time)
3. Download each as it completes
4. Present the full package to the user

## Quality Guidance

**Source quality matters most.** Invest time in getting the right sources rather than
generating from mediocre ones. A notebook with 5 authoritative sources beats one
with 30 shallow ones.

**Use `--append` to steer output quality.** The built-in report formats are good
starting points. Use `--append` to add specificity:
- `--append "Focus on practical implications, not theory"`
- `--append "Include specific numbers and benchmarks where available"`
- `--append "Target audience: C-level executives, keep it non-technical"`

**Review before generating expensive outputs.** Generate a briefing doc or ask
a few questions before committing to audio/video generation (which takes 10-45
minutes and may hit rate limits). Make sure the source material supports what
the user wants.

**Save important chat answers as notes.** When you get a particularly good answer
from `notebooklm ask`, save it with `--save-as-note`. These notes become part of
the notebook's knowledge base and feed into future generation.

**For multi-source analysis**, ask questions that force cross-referencing:
"Where do sources disagree?" and "What does source X say that contradicts source Y?"
produce more insightful outputs than "Summarize everything."
