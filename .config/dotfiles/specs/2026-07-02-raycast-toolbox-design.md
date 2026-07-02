# Raycast Toolbox — Alfred migration design

Date: 2026-07-02
Status: approved

## Goal

Replace the personal Alfred workflows with a single custom Raycast
extension, keeping the `mtg` meeting workflow as the centerpiece, and
track everything portable in dotfiles.

## Repo layout

- Extension source lives at `.config/raycast-extensions/toolbox/`
  (moved from the untracked `raycast/meeting-notes/`). After
  `yadm merge` it materializes at `~/.config/raycast-extensions/toolbox`.
- `.gitignore` gains `.config/raycast-extensions/*/node_modules/`.
  `package-lock.json` is tracked.
- `~/.config/raycast/` (Raycast-owned: access token in `config.json`,
  installed/dev extensions, AI data) is never tracked.
- Install per machine: `npm install && npm run dev` once from the
  source dir; Raycast keeps the dev extension registered afterward.

## mtg CLI change (backward-compatible)

`mtg list --json` items gain fields for the richer UI:

- `start`, `end` (ISO), `location`, `notes`
- `attendees`: `[{ name, status }]`, `organizer`
- `notePath`, `noteExists`

Note-path logic is factored out of `cmdCreate` into a shared helper so
`list` and `create` cannot disagree. Alfred ignores unknown keys, so
the existing Alfred workflow keeps working. No other mtg behavior
changes (fzf flow, create, calendars untouched).

## Extension: `toolbox` (title "Toolbox"), four commands

1. **Browse Meetings** (`view`) — existing day-by-day list. Keeps
   ⌘[ / ⌘] day stepping, ⌘T today, ⌘R refresh. Adds:
   - Detail pane (⌘D toggle): agenda/notes as markdown; metadata for
     time, attendees with RSVP icons, location, note status.
   - Smart primary action: if `noteExists`, "Open Note" via
     `obsidian://` URL; else "Create Note" via `mtg create --uid`.
   - "Join Meeting" action when a Zoom / Google Meet / Teams / Webex
     URL is found in location or notes (extraction in the extension).
2. **Quick Capture** (`view`, form) — multiline text area; on submit,
   format exactly like `~/bin/obsidian-capture` (`- HH:MM first line`,
   continuation lines indented two spaces) and run
   `obsidian daily:append content=…` (newlines escaped as `\n`).
   The CLI script and its floating dialog stay for terminal use.
3. **Daily Note Window** (`no-view`) — `obsidian daily paneType=window`,
   HUD confirmation.
4. **Open Remote Project** (`view`) — list from `rproj list --json`;
   `@host` prefix in search text overrides host (Alfred parity);
   Enter runs `rproj open "host|path"`.

Preferences: `mtgPath` (default `~/bin/mtg`), `calendar` (default
"Work Calendar"), `obsidianPath` (default `/opt/homebrew/bin/obsidian`),
`rprojPath` (default `~/.local/bin/rproj`). Absolute paths matter
because Raycast launches with a minimal PATH.

## What stays manual (documented in extension README)

- Raycast hotkeys/aliases/settings live in `defaults com.raycast.macos`
  plus an internal database; portability is Raycast Export/Import
  (`.rayconfig`) or Cloud Sync — never the repo.
- Store extensions to install: 1Password (replaces Alfred 1Password
  workflow); built-in Toggle System Appearance (replaces Switch
  Appearance); optionally the community Obsidian extension (replaces
  Shimmering Obsidian search).
- Alfred config in the repo is left untouched.

## Error handling & verification

CLI failures surface as failure toasts carrying stderr (existing
pattern). No automated tests (UI glue over existing CLIs). Verify with
`ray lint`, `ray build`, and driving each command in dev mode.

## Out of scope

Menu bar next-meeting command, week overview, snippet migration,
removing Alfred config.
