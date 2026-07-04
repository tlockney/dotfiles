---
name: drafting-communications
description: |
  Use when helping Thomas draft or polish written communications — emails,
  Slack messages, leadership documents, customer replies, vendor correspondence,
  blog posts, or personal notes. Trigger on phrases like "draft an email",
  "help me reply to", "write a Slack message", "write this up for leadership",
  "rewrite this in my voice", "polish this message", "draft a response",
  "help me write", or any request to compose written communication on Thomas's behalf.

  Applies two registers — a professional/work register (default for work and
  professional contexts) and a base/personal register (close friends, blogs,
  non-work correspondence). The skill detects the audience first, then applies
  the matching register.

  Do NOT apply to:
  - Code comments, commit messages, or PR descriptions (those have their own conventions)
  - Documentation written in someone else's voice (READMEs, technical specs in a project's
    house style, ADRs that follow a template)
  - Generic prose where Thomas's voice isn't the point
---

# Drafting Communications in Thomas's Voice

## Why This Exists

Thomas has two distinct writing-style profiles documented in Obsidian:
a base profile (warm-direct, hedged-precise, conversational-professional)
and a professional/work profile that tightens the voice for senior-leadership,
cross-functional, and customer-facing work. This skill captures
both registers and the rules for switching between them, so any drafting
help sounds like Thomas rather than like a generic AI.

The full source profiles live at:
- `Areas/Personal/Writing Style Profile.md` (base)
- `Areas/Personal/Writing Style Profile—Professional.md` (work)

Read those if you need the long form, verbatim samples, or recent updates.
This skill is the operational summary.

## Announce At Start

Say: _"Drafting in Thomas's voice — [professional|personal] register."_

If you had to ask which register, announce the choice once it's settled.

## Step 1 — Detect the audience and pick the register

Look at the audience and topic together. Decide before drafting.

**Professional register** when any of these apply:
- Recipient is a work colleague, leadership, cross-functional peer, direct
  report, vendor, or customer
- Topic is work, a decision, a status update, technical communication
  for stakeholders, or anything Thomas would put his name on in a work context
- Channel is a work email thread, a work Slack channel, a leadership document,
  an MBR contribution, raise documentation, an architectural plan, or similar
- The message could plausibly be forwarded to leadership

**Base/personal register** when any of these apply:
- Recipient is a close friend, family member, or personal correspondent
- Content is a blog post, a personal email, or non-work correspondence
  (e.g., declining an outside recruiter)
- Channel is a personal account or a non-work context

**If it's unclear**, ask one question with 2–3 specific guesses. Example:
> "Quick check before I draft — is this going to (a) someone on the
> team or leadership, (b) a vendor or customer, or (c) a personal contact?
> The register changes."

Do not draft until the register is settled.

## Shared foundation (both registers)

These principles apply regardless of register.

### Voice
- Warm but direct; self-deprecating without false modesty
- Hedge claims rather than overclaim ("I would not claim to be any sort of
  expert", "I've confirmed that this appears to be…")
- Trace provenance — where an idea came from, who recommended it, what
  conversation prompted it
- Surface meta-principles briefly, then move on; don't belabor

### Structural habits
- Bullets are **annotated**, not bare. A bullet without commentary is an
  incomplete thought.
- Mix short and medium sentences; rarely a wall-of-text paragraph
- Section headers (when present) carry the structure of the argument, not
  just the topics
- Sub-bullets carry the "why" or the "next step" under a top-level claim

### Punctuation (exact rules — Thomas is fastidious about these)
- Em-dashes used heavily for parenthetical asides and mid-sentence
  qualifications. **Always unspaced on both sides.** Never `word — word`,
  always `word—word`.
- In plain-text email contexts where rich punctuation isn't available, use
  double-hyphen `--` as the em-dash substitute
- En-dashes get spaces around them; em-dashes never do
- Ellipses for trailing thought or softened transitions
- Semicolons used fluently when the rhythm calls for them, not ornamentally
- Parenthetical asides for tangential information rather than footnotes

### Notably absent in both registers
- Buzzwords, hype language
- Bullet points without annotation
- Uncaveated confident claims about things still in flight
- Formal openings like "I hope this finds you well"
- Em-dashes with surrounding spaces

## Professional register

### BLUF for anything decision-shaped
When the message is intended to inform a decision, change a course of action,
or surface risk to leadership, **the conclusion comes first**. Pattern:

1. **BLUF line** — one sentence stating the position or conclusion. Strong
   voice: "I am strongly of the opinion that…", "I do not believe we can…",
   "We should…", "This is not a technology problem at core."
2. **Confidence/scope caveat** — almost always present, almost always brief.
   "Note that this is after roughly ½ day with the team. I may have different
   opinions tomorrow." Signature move — commits without overclaiming.
3. **Supporting evidence or causal chain** — bullets or short paragraphs.
   Mechanism first, then failure mode, then implication.
4. **Workaround / next step** — even when imperfect. Name the imperfection.

BLUF is for decision-shaped messages only. Status updates, logistics, and
routine threads still open with one-line context — forcing BLUF onto
everything reads as performative.

### First-person voice in owned documents
Documents Thomas authors (leadership docs, raise documentation, MBR
contributions, cost optimization writeups) use first person, not corporate
third person. "I am strongly of the opinion…" not "It is the opinion of the
Product Engineering team that…". First person marks authorship and accountability.

When ghost-writing for someone else (e.g., raise documentation drafted for
a colleague to submit), the first-person voice belongs to *them*, not Thomas.

### Customer impact and business value lead
Technical delivery is rarely the lede in formal communication. Open with
what this means for the customer / for the business / for the SLA. The
technical detail follows as the explanation.

- An SLA discussion opens with the SLA risk, not the implementation detail
- A cost optimization document opens with the projected savings range, not
  the contract structure
- A platform migration update opens with what changes for customers, not the
  architectural diff

### Causal chains over narrative for technical explanations
For technical content aimed at non-technical or partly-technical audiences,
the structure is **mechanism → failure mode → implication**, in that order.
Senior readers want the chain stated cleanly so they can probe it. Skip the
"let me walk you through what I found" narrative — that's a base-register move.

### Hedged precision — sharpened
Hedging at work marks the boundary between what's been confirmed and what's
being inferred:

- "I've confirmed that this appears to be what amounts to a bug" — committed
  enough to act on, qualified enough about certainty
- "I think (not confirmed, but feels this way) that some of the changes…" —
  explicit confidence labeling when stakes are higher
- "I may have different opinions tomorrow" — time-bounding the commitment

The hedging signals epistemic discipline, not diffidence. Don't reach for it
reflexively.

### Acknowledge the imperfect path forward
When proposing a workaround, partial fix, or compromise, name it as such:
"we at least now have a definitive 'work around' even if it is far from ideal."
Preserves credibility and tees up the longer-term fix as a separate conversation.

### Audience-calibrated formality
- **C-suite / senior leadership**: BLUF, first person, customer/business
  framing, brief. Trust their ability to ask follow-ups.
- **Cross-functional peers (engineering, PM, ops)**: BLUF when decision-shaped,
  otherwise context-first. Causal chains for technical content. Some warmth —
  these are working relationships.
- **Direct reports / team**: Closer to base profile. Context, reasoning, and
  hedging more visible. Coaching tone where appropriate.
- **External vendors**: Plain, structured, factual. Less hedging — vendors
  need clarity on what is and isn't acceptable.
- **Customers**: Customer-impact framing exclusively. Technical detail only
  when it explains an action or a delay.

### Distinctive work tics
- "Following up on this, I've confirmed…" — opener for closing a previously-open
  technical loop
- "To add a bit of color to [name]'s summary…" — extending someone else's
  writeup with your own analysis
- "This is not how this should work…" — flagging a design issue without piling
  on adjectives
- "I am strongly of the opinion that…" — BLUF entry for a contested or
  directive position
- Direct @-mentions in long threads to assign specific actions rather than
  burying the ask in prose

### Notably absent at work
- Profanity (allowed with close friends in personal register; never at work)
- Originated exclamation points (mirroring a peer's "thank you!" is fine;
  originating one is rare)
- Apologetic openings — "Sorry for the delay" appears in personal email but
  not in leadership communication, where it reads as undermining
- Speculative architectural detail in upward communication — the mechanism
  gets stated when relevant; deeper architectural reasoning lives in technical
  plans, not in messages to leadership
- Dry-humor closers and jokes that invite themselves into the situation

## Base / personal register

### Defaults
- Open with one-line context, deliver the ask or response, close quickly
- Acknowledge delay or scheduling friction up front when relevant
  ("Sorry for the delay -- been a very busy few weeks")
- Context before ask, reasoning before conclusion
- Looser register with close friends — profanity is on the table, dry humor
  fits, exclamation points are allowed when genuine

### Lexical tics
- "FWIW" / "For what it's worth" — hedge before sharing information
- "That said," — pivot between acknowledgment and pushback
- "Quite", "fairly", "pretty", "really" — default intensifiers/hedges
- "Somehow" / "somehow stumbled on" — discovery framing
- ";-)" and ";~)" — winking/self-aware markers (rarely other emoticons)

### Openings and closings
- Greetings: "Hi [name],", "Hey [name],", "Hi all,"
- Sign-offs by closeness:
  - Personal/close: `~thomas`, `~t`, `-t`
  - Professional: "Thanks!" or "Thanks,"
- Signature blocks use a plain `--` delimiter
- Acknowledgments are specific — name the person, reference what they did

### Framing habits
- Locate yourself in a broader context when declining or accepting — don't
  just say no, explain existing involvement and current investment

## Final-pass checklist

Before delivering a draft, verify:

1. **Register matches audience.** Professional cues → professional register;
   personal cues → base register. If you guessed, the guess held up.
2. **BLUF if decision-shaped** (professional register only). The first
   sentence states the position; reasoning follows.
3. **Hedges are intentional, not reflexive.** Each "I think" / "appears to be" /
   "fairly" marks a real boundary of confidence.
4. **No buzzwords, no hype language.** Plain words.
5. **Em-dashes unspaced.** Every one. `word—word`, not `word — word`.
6. **Bullets are annotated.** No bare-fact bullets.
7. **No apologetic openings** in professional register; no originated
   exclamation points.
8. **Sign-off matches closeness.** `~t` to a close friend, "Thanks," to a peer,
   nothing more formal than that.
9. **Customer/business framing leads** (professional register, when persuading).
10. **Causal chain stated cleanly** (professional register, when explaining
    something technical).

If any item fails, fix it before delivering.

## When in doubt

Ask. A short clarifying question is cheaper than a draft in the wrong register.
Examples:
- "Is this going to leadership or to the team? The framing changes."
- "Decision-shaped or status-shaped? BLUF or context-first?"
- "How close is this person — `~t` close, or 'Thanks,' close?"
