# Toolbox (Raycast)

Personal Raycast commands: browsing meetings, capturing notes, and
opening remote projects. Thin UI shells over CLIs tracked elsewhere
in this repo (`mtg`, `obsidian`, `rproj`). Replaces a set of retired
Alfred workflows.

## Commands

- **Browse Meetings** — day-by-day list view backed by `mtg list
  --json`. `Cmd+[` / `Cmd+]` step back/forward a day, `Cmd+T` jumps
  to today, `Cmd+D` toggles the detail pane, `Cmd+R` refreshes, and
  `Cmd+J` joins the meeting when the invite has a Zoom/Meet/Teams/
  Webex URL. The primary action opens the Obsidian note if one
  exists, otherwise creates it via `mtg create --uid`.
- **Quick Capture** — a multiline text area appended to today's
  Obsidian daily note via `obsidian daily:append`. Entries are
  formatted `- HH:MM first line`, with continuation lines indented
  two spaces.
- **Daily Note Window** — no-view command that runs `obsidian daily
  paneType=window` to open today's note in its own window.
- **Open Remote Project** — list view sourced from `rproj list
  --json`. Typing filters the list; prefix a query with `@host` to
  pin results to that host (`rproj list -h HOST`). Enter runs `rproj
  open "host|path"`.

## Preferences

Set in Raycast under Extensions → Toolbox:

- `mtgPath` — path to the `mtg` CLI (default `~/bin/mtg`)
- `calendar` — calendar name(s) passed to `mtg --calendar` (default
  `Work Calendar`)
- `obsidianPath` — path to the `obsidian` CLI (default
  `/opt/homebrew/bin/obsidian`)
- `rprojPath` — path to the `rproj` CLI (default
  `~/.local/bin/rproj`)

## Dependency: mtg

Browse Meetings needs the enriched `mtg list --json` output shipped
by this repo's `bin/mtg`. Apply it to `~/bin/mtg` by running `yadm
fetch && yadm merge origin/main` from the home directory.

## Install / development

Once per machine:

```sh
cd ~/.config/raycast-extensions/toolbox
npm install
npm run dev   # registers the commands with Raycast in dev mode
```

After the first `npm run dev`, Raycast keeps the dev extension
registered — you don't need to rerun it on every change unless you
want live reload while iterating.

If a stale `meeting-notes` dev extension is still registered from an
earlier iteration of this project, remove it: Raycast → Extensions →
right-click `meeting-notes` → Remove.

## Where Raycast's own config lives

`~/.config/raycast-extensions/` (this checkout) holds extension
*source* only — `node_modules` is gitignored, and everything here is
tracked normally in the dotfiles repo.

Raycast's own state lives in `~/.config/raycast/`: `config.json`
(contains a Raycast access token — a secret, never commit),
installed/dev extension bundles, and AI data. App settings and
hotkey bindings live in `defaults com.raycast.macos` plus an
internal database, not in a dotfile. None of that directory is
tracked here; move it between machines with Raycast's own
Export/Import (`.rayconfig`) or Cloud Sync.

## Replacing retired Alfred workflows

A few Alfred workflows didn't get a custom command here because
Raycast already covers them:

- **1Password** — install the official 1Password store extension.
- **Toggle System Appearance** — built into Raycast; no extension
  needed.
- **Obsidian search** (replaces Shimmering Obsidian) — optional, via
  the community Obsidian store extension.

Hotkeys and aliases for any command (including the ones in this
extension) are assigned manually: Raycast Settings → Extensions →
select the command → set its hotkey/alias.

## Icon

`assets/icon.png` is a placeholder. Drop in a 512×512 PNG for a
better look in the Raycast root search.
