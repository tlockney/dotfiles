# Meeting Notes (Raycast)

Browse calendar events day-by-day and create Obsidian meeting notes. Thin UI shell over the [`mtg`](../../bin/mtg) CLI.

## Commands

- **Browse Meetings** — list view for a target day. `Cmd+[` / `Cmd+]` step back/forward by day; `Cmd+T` jumps to today. Enter on a meeting calls `mtg create --uid …` to create the note and open it in Obsidian.

## Development

```sh
cd raycast/meeting-notes
npm install
npm run dev   # opens the command in Raycast in dev mode
```

Requires the `mtg` CLI on `PATH` (or set the absolute path in extension preferences).

## Icon

`assets/icon.png` is a placeholder. Drop in a 512×512 PNG for a better look in the Raycast root search.
