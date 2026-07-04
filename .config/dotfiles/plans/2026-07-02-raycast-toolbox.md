# Raycast Toolbox Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace personal Alfred workflows with a single Raycast extension (`toolbox`) tracked in dotfiles, with the `mtg` meeting workflow as the centerpiece.

**Architecture:** A four-command Raycast extension at `.config/raycast-extensions/toolbox/` that shells out to existing CLIs (`mtg`, `obsidian`, `rproj`). `mtg list --json` is enriched (backward-compatibly) so the UI gets attendees/location/notes/note-status without duplicating note-path logic.

**Tech Stack:** Raycast API (React/TypeScript, built with `ray`), Deno (for `mtg`), existing CLIs.

## Global Constraints

- Repo is a yadm worktree at `~/src/personal/dotfiles` on `working-branch`; paths are home-relative (e.g. `bin/mtg` → `~/bin/mtg` after `yadm merge`).
- `git status` hides untracked files (`status.showUntrackedFiles=no`) — always `git add` new paths explicitly and verify with `git status --short -- <path>`.
- Commit messages must never mention Claude, AI, or automated assistance. No session trailers.
- TypeScript: never `any`; use `unknown` + narrowing.
- No automated tests (approved in spec §5): verify with `deno check`, `npm run lint`, `npm run build`, and manual runs.
- Live `~/bin/mtg` is the *merged* copy; test mtg changes by executing the worktree copy: `~/src/personal/dotfiles/bin/mtg`.
- Do not modify Alfred config, `~/bin/obsidian-capture`, or mtg's fzf/create flows beyond what a task specifies.

---

### Task 1: Move extension source into tracked location and rename to `toolbox`

**Files:**
- Move: `raycast/meeting-notes/` → `.config/raycast-extensions/toolbox/` (drop `node_modules/`)
- Modify: `.config/raycast-extensions/toolbox/package.json`
- Modify: `.gitignore`

**Interfaces:**
- Produces: extension root `.config/raycast-extensions/toolbox/` with existing `src/browse-meetings.tsx`; later tasks add files under its `src/`.

- [ ] **Step 1: Move the directory, excluding node_modules**

```bash
cd ~/src/personal/dotfiles
mkdir -p .config/raycast-extensions
mv raycast/meeting-notes .config/raycast-extensions/toolbox
rm -rf .config/raycast-extensions/toolbox/node_modules
rmdir raycast
```

- [ ] **Step 2: Update package name/title and add new preferences**

In `.config/raycast-extensions/toolbox/package.json`, change:

```json
  "name": "toolbox",
  "title": "Toolbox",
  "description": "Personal commands: meetings, Obsidian capture, remote projects.",
```

and extend the `preferences` array (keep `mtgPath` and `calendar` as they are):

```json
    {
      "name": "obsidianPath",
      "title": "Obsidian CLI",
      "description": "Absolute path to the obsidian CLI.",
      "type": "textfield",
      "default": "/opt/homebrew/bin/obsidian",
      "required": false
    },
    {
      "name": "rprojPath",
      "title": "rproj binary",
      "description": "Absolute path to the rproj CLI.",
      "type": "textfield",
      "default": "~/.local/bin/rproj",
      "required": false
    }
```

- [ ] **Step 3: Add node_modules ignore rule**

Append to `.gitignore` (root of repo):

```gitignore
.config/raycast-extensions/*/node_modules/
```

- [ ] **Step 4: Reinstall dependencies and verify build**

```bash
cd ~/src/personal/dotfiles/.config/raycast-extensions/toolbox
npm install
npm run build
```

Expected: `ray build` completes without errors (warnings about the placeholder icon are fine).

- [ ] **Step 5: Commit**

```bash
cd ~/src/personal/dotfiles
git add .gitignore .config/raycast-extensions/toolbox
git status --short -- .config/raycast-extensions .gitignore   # confirm files staged, no node_modules
git commit -m "raycast: track toolbox extension source, moved from untracked raycast/"
```

---

### Task 2: Enrich `mtg list --json` with detail/note fields

**Files:**
- Modify: `bin/mtg` (helpers near `openInObsidian` ~line 168; `cmdList` ~line 330; `cmdListAlfred` ~line 466; `cmdCreate` ~line 711)

**Interfaces:**
- Produces (consumed by Task 3): each real event item in `mtg list --json` output additionally has:
  `start: string` (ISO), `end: string` (ISO), `location: string`, `notes: string`,
  `attendees: Array<{name: string; status: string}>` (self filtered out), `organizer: string`,
  `notePath: string` (absolute), `noteExists: boolean`, `obsidianUri: string`.

- [ ] **Step 1: Add note-info and URI helpers; refactor `openInObsidian`**

In `bin/mtg`, replace the existing `openInObsidian` function with:

```ts
function obsidianUriForNote(filename: string): string {
  const noteName = filename.replace(/\.md$/, "");
  const encoded = encodeURIComponent(`Active/Metron/Meetings/${noteName}`);
  return `obsidian://open?vault=Personal&file=${encoded}`;
}

function openInObsidian(filename: string): void {
  const cmd = new Deno.Command("open", {
    args: [obsidianUriForNote(filename)],
    stderr: "null",
  });
  cmd.outputSync();
}

function noteInfoForEvent(event: CalendarEvent): {
  filename: string;
  filepath: string;
  meetingLink: string;
} {
  const localDate = formatDate(toLocalDate(event.start));
  const safeTitle = sanitizeFilename(event.title);
  const filename = `${safeTitle} - ${localDate}.md`;
  return {
    filename,
    filepath: join(MEETINGS_DIR, filename),
    meetingLink: `${safeTitle} - ${localDate}`,
  };
}
```

- [ ] **Step 2: Add a shared JSON item builder**

Add directly below `noteInfoForEvent`:

```ts
function eventJsonItem(event: CalendarEvent): Record<string, unknown> {
  const start = toLocalDate(event.start);
  const end = toLocalDate(event.end);
  const inviteeCount = getInvitees(event).length;
  const note = noteInfoForEvent(event);
  return {
    uid: event.uid,
    title: event.title,
    subtitle: `${formatTime(start)} - ${formatTime(end)} • ${inviteeCount} invitees`,
    arg: event.uid,
    autocomplete: event.title,
    start: event.start,
    end: event.end,
    location: event.location ?? "",
    notes: event.notes ?? "",
    attendees: (event.attendees ?? [])
      .filter((a) => a.name && a.name !== SELF_NAME)
      .map((a) => ({ name: a.name, status: a.status })),
    organizer: event.organizer?.name ?? "",
    notePath: note.filepath,
    noteExists: existsSync(note.filepath),
    obsidianUri: obsidianUriForNote(note.filename),
  };
}
```

- [ ] **Step 3: Use the builder in both JSON list paths**

In `cmdList` (jsonMode branch), replace the `.map((event) => { ... })` callback body with `.map(eventJsonItem)`.

In `cmdListAlfred`, replace the per-event `items.push({ uid: event.uid, title: ..., subtitle: ..., arg: ..., autocomplete: ... })` block inside the `for (const event of filtered)` loop with:

```ts
      items.push(eventJsonItem(event));
```

- [ ] **Step 4: Use `noteInfoForEvent` in `cmdCreate`**

In `cmdCreate`, replace:

```ts
  // Build file path
  const safeTitle = sanitizeFilename(event.title);
  const filename = `${safeTitle} - ${localDate}.md`;
  const filepath = join(MEETINGS_DIR, filename);

  const meetingLink = `${safeTitle} - ${localDate}`;
```

with:

```ts
  // Build file path
  const { filename, filepath, meetingLink } = noteInfoForEvent(event);
```

(`localDate` is still used earlier in the function for frontmatter — leave its declaration alone.)

- [ ] **Step 5: Verify**

```bash
cd ~/src/personal/dotfiles
deno check bin/mtg
./bin/mtg list --json | jq '.items[] | select(.uid) | {title, start, noteExists, obsidianUri, attendees: (.attendees | length)}' | head -30
./bin/mtg list --json --date 2026-07-01 | jq '.items | length'
```

Expected: type-check passes; real events show the new fields; a past date still returns items (nav placeholders and/or events).

- [ ] **Step 6: Commit**

```bash
git add bin/mtg
git commit -m "mtg: emit event details and note status in JSON list output"
```

---

### Task 3: Polish Browse Meetings — detail pane, smart open/create, join link

**Files:**
- Create: `.config/raycast-extensions/toolbox/src/lib/exec.ts`
- Create: `.config/raycast-extensions/toolbox/src/lib/meeting-link.ts`
- Modify: `.config/raycast-extensions/toolbox/src/browse-meetings.tsx`

**Interfaces:**
- Consumes: enriched `mtg list --json` fields from Task 2.
- Produces (reused by Tasks 4–6): `execFileAsync(file, args)` and `expandTilde(input): string` from `src/lib/exec.ts`.

- [ ] **Step 1: Create `src/lib/exec.ts`**

```ts
import { execFile } from "node:child_process";
import { homedir } from "node:os";
import { resolve } from "node:path";
import { promisify } from "node:util";

export const execFileAsync = promisify(execFile);

export function expandTilde(input: string): string {
  if (input === "~") return homedir();
  if (input.startsWith("~/")) return resolve(homedir(), input.slice(2));
  return input;
}

export function errorMessage(err: unknown): string {
  return err instanceof Error ? err.message : String(err);
}
```

- [ ] **Step 2: Create `src/lib/meeting-link.ts`**

```ts
// Matches the join URLs of the conferencing services we actually encounter.
const MEETING_URL_PATTERN =
  /https?:\/\/[^\s<>"']*(?:zoom\.us\/j\/|meet\.google\.com\/|teams\.microsoft\.com\/l\/meetup-join|webex\.com\/(?:meet|join)\/)[^\s<>"']*/i;

export function extractMeetingUrl(
  ...sources: Array<string | undefined>
): string | undefined {
  for (const source of sources) {
    const match = source?.match(MEETING_URL_PATTERN);
    if (match) return match[0];
  }
  return undefined;
}
```

- [ ] **Step 3: Rewrite `src/browse-meetings.tsx`**

Keep the existing day-navigation model; add detail pane, smart primary action, and join action. Full file:

```tsx
import {
  Action,
  ActionPanel,
  Icon,
  List,
  Toast,
  getPreferenceValues,
  showToast,
} from "@raycast/api";
import { useCachedPromise } from "@raycast/utils";
import { useMemo, useState } from "react";
import { errorMessage, execFileAsync, expandTilde } from "./lib/exec";
import { extractMeetingUrl } from "./lib/meeting-link";

interface Preferences {
  mtgPath?: string;
  calendar?: string;
}

interface MtgAttendee {
  name: string;
  status: string;
}

// Shape produced by `mtg list --json`. Real events have a `uid`; nav/empty
// placeholder rows don't, so we filter on that.
interface MtgJsonItem {
  uid?: string;
  title: string;
  subtitle: string;
  start?: string;
  end?: string;
  location?: string;
  notes?: string;
  attendees?: MtgAttendee[];
  organizer?: string;
  notePath?: string;
  noteExists?: boolean;
  obsidianUri?: string;
}

interface MtgJson {
  items: MtgJsonItem[];
}

function formatYmd(d: Date): string {
  const y = d.getFullYear();
  const m = String(d.getMonth() + 1).padStart(2, "0");
  const dd = String(d.getDate()).padStart(2, "0");
  return `${y}-${m}-${dd}`;
}

function addDays(d: Date, n: number): Date {
  const next = new Date(d);
  next.setDate(d.getDate() + n);
  return next;
}

function dayLabel(d: Date): string {
  const weekday = d.toLocaleDateString("en-US", { weekday: "long" });
  return `${weekday}, ${formatYmd(d)}`;
}

function sameDay(a: Date, b: Date): boolean {
  return formatYmd(a) === formatYmd(b);
}

function formatClock(iso?: string): string | undefined {
  if (!iso) return undefined;
  return new Date(iso).toLocaleTimeString("en-US", {
    hour: "2-digit",
    minute: "2-digit",
    hour12: false,
  });
}

function rsvpIcon(status: string): Icon {
  switch (status.toLowerCase()) {
    case "accepted":
      return Icon.CheckCircle;
    case "declined":
      return Icon.XMarkCircle;
    case "tentative":
      return Icon.QuestionMarkCircle;
    default:
      return Icon.Circle;
  }
}

export default function Command() {
  const prefs = getPreferenceValues<Preferences>();
  const mtgPath = useMemo(
    () => expandTilde((prefs.mtgPath ?? "").trim() || "~/bin/mtg"),
    [prefs.mtgPath],
  );
  const calendar = (prefs.calendar ?? "").trim() || "Work Calendar";

  const [date, setDate] = useState<Date>(() => new Date());
  const [showDetail, setShowDetail] = useState(true);
  const dateStr = formatYmd(date);

  const { isLoading, data, revalidate, error } = useCachedPromise(
    async (bin: string, day: string, cal: string): Promise<MtgJson> => {
      const { stdout } = await execFileAsync(bin, [
        "list",
        "--json",
        "--date",
        day,
        "--calendar",
        cal,
      ]);
      return JSON.parse(stdout) as MtgJson;
    },
    [mtgPath, dateStr, calendar],
    { keepPreviousData: true },
  );

  const meetings = (data?.items ?? []).filter(
    (i): i is MtgJsonItem & { uid: string } => Boolean(i.uid),
  );

  async function createNote(uid: string, title: string) {
    const toast = await showToast({
      style: Toast.Style.Animated,
      title: "Creating note…",
      message: title,
    });
    try {
      await execFileAsync(mtgPath, ["create", "--uid", uid]);
      toast.style = Toast.Style.Success;
      toast.title = "Note created";
      toast.message = title;
      revalidate();
    } catch (err) {
      toast.style = Toast.Style.Failure;
      toast.title = "Failed to create note";
      toast.message = errorMessage(err);
    }
  }

  const navActions = (
    <>
      <Action
        title="Previous Day"
        icon={Icon.ArrowLeft}
        shortcut={{ modifiers: ["cmd"], key: "[" }}
        onAction={() => setDate((d) => addDays(d, -1))}
      />
      <Action
        title="Next Day"
        icon={Icon.ArrowRight}
        shortcut={{ modifiers: ["cmd"], key: "]" }}
        onAction={() => setDate((d) => addDays(d, 1))}
      />
      <Action
        title="Today"
        icon={Icon.Calendar}
        shortcut={{ modifiers: ["cmd"], key: "t" }}
        onAction={() => setDate(new Date())}
      />
      <Action
        title="Toggle Details"
        icon={Icon.AppWindowSidebarRight}
        shortcut={{ modifiers: ["cmd"], key: "d" }}
        onAction={() => setShowDetail((v) => !v)}
      />
      <Action
        title="Refresh"
        icon={Icon.ArrowClockwise}
        shortcut={{ modifiers: ["cmd"], key: "r" }}
        onAction={() => revalidate()}
      />
    </>
  );

  const navigationTitle = `Meetings · ${dayLabel(date)}${
    sameDay(date, new Date()) ? "  (today)" : ""
  }`;

  return (
    <List
      isLoading={isLoading}
      isShowingDetail={showDetail && meetings.length > 0}
      navigationTitle={navigationTitle}
      searchBarPlaceholder={`Filter meetings on ${dateStr}…`}
    >
      {error ? (
        <List.EmptyView
          icon={Icon.ExclamationMark}
          title="mtg failed"
          description={errorMessage(error)}
          actions={<ActionPanel>{navActions}</ActionPanel>}
        />
      ) : meetings.length === 0 ? (
        <List.EmptyView
          icon={Icon.Calendar}
          title={`No meetings on ${dayLabel(date)}`}
          description="Use ⌘[ / ⌘] to step days, ⌘T for today."
          actions={<ActionPanel>{navActions}</ActionPanel>}
        />
      ) : (
        meetings.map((item) => {
          const time = [formatClock(item.start), formatClock(item.end)]
            .filter(Boolean)
            .join(" – ");
          const joinUrl = extractMeetingUrl(item.location, item.notes);
          const attendees = item.attendees ?? [];
          return (
            <List.Item
              key={item.uid}
              icon={item.noteExists ? Icon.CheckCircle : Icon.Calendar}
              title={item.title}
              accessories={
                showDetail
                  ? [{ text: time }]
                  : [
                      { tag: time, icon: Icon.Clock },
                      { text: `${attendees.length}`, icon: Icon.Person },
                    ]
              }
              detail={
                <List.Item.Detail
                  markdown={
                    item.notes?.trim()
                      ? item.notes
                      : "*No agenda / notes on the invite.*"
                  }
                  metadata={
                    <List.Item.Detail.Metadata>
                      <List.Item.Detail.Metadata.Label
                        title="Time"
                        text={time || "—"}
                        icon={Icon.Clock}
                      />
                      <List.Item.Detail.Metadata.Label
                        title="Note"
                        text={item.noteExists ? "Exists" : "Not created"}
                        icon={item.noteExists ? Icon.CheckCircle : Icon.Circle}
                      />
                      {item.location ? (
                        <List.Item.Detail.Metadata.Label
                          title="Location"
                          text={item.location}
                          icon={Icon.Pin}
                        />
                      ) : null}
                      {item.organizer ? (
                        <List.Item.Detail.Metadata.Label
                          title="Organizer"
                          text={item.organizer}
                          icon={Icon.PersonCircle}
                        />
                      ) : null}
                      {attendees.length > 0 ? (
                        <List.Item.Detail.Metadata.Separator />
                      ) : null}
                      {attendees.map((a) => (
                        <List.Item.Detail.Metadata.Label
                          key={a.name}
                          title={a.name}
                          text={a.status}
                          icon={rsvpIcon(a.status)}
                        />
                      ))}
                    </List.Item.Detail.Metadata>
                  }
                />
              }
              actions={
                <ActionPanel>
                  {item.noteExists && item.obsidianUri ? (
                    <Action.Open
                      title="Open Note in Obsidian"
                      icon={Icon.Document}
                      target={item.obsidianUri}
                    />
                  ) : (
                    <Action
                      title="Create Meeting Note"
                      icon={Icon.NewDocument}
                      onAction={() => createNote(item.uid, item.title)}
                    />
                  )}
                  {joinUrl ? (
                    <Action.OpenInBrowser
                      title="Join Meeting"
                      icon={Icon.Video}
                      url={joinUrl}
                      shortcut={{ modifiers: ["cmd"], key: "j" }}
                    />
                  ) : null}
                  <ActionPanel.Section title="Navigate">
                    {navActions}
                  </ActionPanel.Section>
                </ActionPanel>
              }
            />
          );
        })
      )}
    </List>
  );
}
```

- [ ] **Step 4: Verify**

```bash
cd ~/src/personal/dotfiles/.config/raycast-extensions/toolbox
npm run lint
npm run build
```

Expected: both pass. Then `npm run dev` and manually check: detail pane renders, ⌘D toggles it, ⌘[/⌘]/⌘T navigate, a meeting with an existing note shows "Open Note in Obsidian", one without shows "Create Meeting Note", a meeting with a Zoom/Meet URL shows "Join Meeting".

Note: until `yadm merge`, `~/bin/mtg` lacks the new fields — point the extension's `mtg binary` preference at `~/src/personal/dotfiles/bin/mtg` while testing (Raycast → command preferences), or temporarily copy the worktree mtg over `~/bin/mtg`.

- [ ] **Step 5: Commit**

```bash
cd ~/src/personal/dotfiles
git add .config/raycast-extensions/toolbox/src
git commit -m "raycast: add detail pane, smart note action, and join link to Browse Meetings"
```

---

### Task 4: Quick Capture command

**Files:**
- Create: `.config/raycast-extensions/toolbox/src/quick-capture.tsx`
- Modify: `.config/raycast-extensions/toolbox/package.json` (commands array)

**Interfaces:**
- Consumes: `execFileAsync`, `expandTilde`, `errorMessage` from `src/lib/exec.ts`; `obsidianPath` preference (Task 1).

- [ ] **Step 1: Add command entry to `package.json`**

```json
    {
      "name": "quick-capture",
      "title": "Quick Capture",
      "subtitle": "Toolbox",
      "description": "Append a timestamped entry to today's Obsidian daily note.",
      "mode": "view"
    }
```

- [ ] **Step 2: Create `src/quick-capture.tsx`**

Formatting matches `~/bin/obsidian-capture`: `- HH:MM first line`, continuation lines indented two spaces, newlines escaped as `\n` for the CLI.

```tsx
import {
  Action,
  ActionPanel,
  Form,
  Toast,
  getPreferenceValues,
  popToRoot,
  showHUD,
  showToast,
} from "@raycast/api";
import { useState } from "react";
import { errorMessage, execFileAsync, expandTilde } from "./lib/exec";

interface Preferences {
  obsidianPath?: string;
}

export function formatEntry(text: string, timestamp: string): string {
  const lines = text.split("\n");
  const first = `- ${timestamp} ${lines[0]}`;
  const rest = lines.slice(1).map((line) => `  ${line}`);
  return [first, ...rest].join("\n");
}

export default function Command() {
  const prefs = getPreferenceValues<Preferences>();
  const obsidianPath = expandTilde(
    (prefs.obsidianPath ?? "").trim() || "/opt/homebrew/bin/obsidian",
  );
  const [text, setText] = useState("");

  async function handleSubmit(values: { text: string }) {
    const captured = values.text.trimEnd();
    if (!captured.trim()) {
      await showToast({ style: Toast.Style.Failure, title: "Nothing to capture" });
      return;
    }
    const now = new Date();
    const timestamp = `${String(now.getHours()).padStart(2, "0")}:${String(
      now.getMinutes(),
    ).padStart(2, "0")}`;
    const entry = formatEntry(captured, timestamp).replaceAll("\n", "\\n");
    try {
      await execFileAsync(obsidianPath, ["daily:append", `content=${entry}`]);
      await showHUD("Captured to daily note");
      await popToRoot();
    } catch (err) {
      await showToast({
        style: Toast.Style.Failure,
        title: "Capture failed",
        message: errorMessage(err),
      });
    }
  }

  return (
    <Form
      actions={
        <ActionPanel>
          <Action.SubmitForm title="Capture" onSubmit={handleSubmit} />
        </ActionPanel>
      }
    >
      <Form.TextArea
        id="text"
        title="Capture"
        placeholder="What's on your mind? (multiline supported)"
        value={text}
        onChange={setText}
        autoFocus
      />
    </Form>
  );
}
```

- [ ] **Step 3: Verify**

```bash
cd ~/src/personal/dotfiles/.config/raycast-extensions/toolbox
npm run lint && npm run build
```

Expected: pass. In `npm run dev`, capture a two-line entry and confirm it lands in today's daily note as `- HH:MM line1` + indented `line2`.

- [ ] **Step 4: Commit**

```bash
cd ~/src/personal/dotfiles
git add .config/raycast-extensions/toolbox/src/quick-capture.tsx .config/raycast-extensions/toolbox/package.json
git commit -m "raycast: add Quick Capture command for Obsidian daily note"
```

---

### Task 5: Daily Note Window command

**Files:**
- Create: `.config/raycast-extensions/toolbox/src/daily-note.ts`
- Modify: `.config/raycast-extensions/toolbox/package.json` (commands array)

**Interfaces:**
- Consumes: `execFileAsync`, `expandTilde`, `errorMessage` from `src/lib/exec.ts`; `obsidianPath` preference.

- [ ] **Step 1: Add command entry to `package.json`**

```json
    {
      "name": "daily-note",
      "title": "Daily Note Window",
      "subtitle": "Toolbox",
      "description": "Open today's daily note in a dedicated Obsidian window.",
      "mode": "no-view"
    }
```

- [ ] **Step 2: Create `src/daily-note.ts`**

```ts
import {
  Toast,
  closeMainWindow,
  getPreferenceValues,
  showHUD,
  showToast,
} from "@raycast/api";
import { errorMessage, execFileAsync, expandTilde } from "./lib/exec";

interface Preferences {
  obsidianPath?: string;
}

export default async function Command() {
  const prefs = getPreferenceValues<Preferences>();
  const obsidianPath = expandTilde(
    (prefs.obsidianPath ?? "").trim() || "/opt/homebrew/bin/obsidian",
  );
  try {
    await closeMainWindow();
    await execFileAsync(obsidianPath, ["daily", "paneType=window"]);
    await showHUD("Opened daily note");
  } catch (err) {
    await showToast({
      style: Toast.Style.Failure,
      title: "Failed to open daily note",
      message: errorMessage(err),
    });
  }
}
```

- [ ] **Step 3: Verify**

```bash
npm run lint && npm run build
```

Expected: pass. In dev mode, running the command opens today's note in a new Obsidian window.

- [ ] **Step 4: Commit**

```bash
cd ~/src/personal/dotfiles
git add .config/raycast-extensions/toolbox/src/daily-note.ts .config/raycast-extensions/toolbox/package.json
git commit -m "raycast: add Daily Note Window command"
```

---

### Task 6: Open Remote Project command

**Files:**
- Create: `.config/raycast-extensions/toolbox/src/remote-projects.tsx`
- Modify: `.config/raycast-extensions/toolbox/package.json` (commands array)

**Interfaces:**
- Consumes: `execFileAsync`, `expandTilde`, `errorMessage` from `src/lib/exec.ts`; `rprojPath` preference.
- `rproj list --json [-h HOST]` returns `{ items: [{ uid, title, subtitle, arg, autocomplete }] }` where `arg` is `"host|path"`; `rproj open "host|path"` opens VS Code.

- [ ] **Step 1: Add command entry to `package.json`**

```json
    {
      "name": "remote-projects",
      "title": "Open Remote Project",
      "subtitle": "Toolbox",
      "description": "Browse and open remote projects in VS Code via rproj.",
      "mode": "view"
    }
```

- [ ] **Step 2: Create `src/remote-projects.tsx`**

`@host` prefix in the search bar pins the host (Alfred parity); the rest of the text filters titles. Filtering is manual because the `@host` token would defeat Raycast's native filter.

```tsx
import {
  Action,
  ActionPanel,
  Icon,
  List,
  Toast,
  closeMainWindow,
  getPreferenceValues,
  showHUD,
  showToast,
} from "@raycast/api";
import { useCachedPromise } from "@raycast/utils";
import { useMemo, useState } from "react";
import { errorMessage, execFileAsync, expandTilde } from "./lib/exec";

interface Preferences {
  rprojPath?: string;
}

interface RprojItem {
  uid?: string;
  title: string;
  subtitle?: string;
  arg?: string;
  autocomplete?: string;
}

interface RprojJson {
  items: RprojItem[];
}

function parseQuery(searchText: string): { host?: string; filter: string } {
  const match = searchText.match(/^@(\S*)\s*(.*)$/);
  if (!match) return { filter: searchText.trim() };
  return { host: match[1] || undefined, filter: match[2].trim() };
}

export default function Command() {
  const prefs = getPreferenceValues<Preferences>();
  const rprojPath = useMemo(
    () => expandTilde((prefs.rprojPath ?? "").trim() || "~/.local/bin/rproj"),
    [prefs.rprojPath],
  );
  const [searchText, setSearchText] = useState("");
  const { host, filter } = parseQuery(searchText);

  const { isLoading, data, error } = useCachedPromise(
    async (bin: string, hostArg?: string): Promise<RprojJson> => {
      const args = ["list", "--json"];
      if (hostArg) args.push("-h", hostArg);
      const { stdout } = await execFileAsync(bin, args);
      return JSON.parse(stdout) as RprojJson;
    },
    [rprojPath, host],
    { keepPreviousData: true },
  );

  const projects = (data?.items ?? [])
    .filter((i): i is RprojItem & { arg: string } => Boolean(i.arg))
    .filter((i) => {
      if (!filter) return true;
      const haystack = `${i.title} ${i.autocomplete ?? ""}`.toLowerCase();
      return haystack.includes(filter.toLowerCase());
    });

  async function openProject(arg: string, title: string) {
    try {
      await closeMainWindow();
      await execFileAsync(rprojPath, ["open", arg]);
      await showHUD(`Opening ${title}`);
    } catch (err) {
      await showToast({
        style: Toast.Style.Failure,
        title: "Failed to open project",
        message: errorMessage(err),
      });
    }
  }

  return (
    <List
      isLoading={isLoading}
      filtering={false}
      onSearchTextChange={setSearchText}
      searchBarPlaceholder="Filter projects, @host to pin a host…"
    >
      {error ? (
        <List.EmptyView
          icon={Icon.ExclamationMark}
          title="rproj failed"
          description={errorMessage(error)}
        />
      ) : (
        projects.map((item) => (
          <List.Item
            key={item.arg}
            icon={Icon.Code}
            title={item.title}
            subtitle={item.subtitle}
            actions={
              <ActionPanel>
                <Action
                  title="Open in VS Code"
                  icon={Icon.Code}
                  onAction={() => openProject(item.arg, item.title)}
                />
                <Action.CopyToClipboard
                  title="Copy Host|path"
                  content={item.arg}
                />
              </ActionPanel>
            }
          />
        ))
      )}
    </List>
  );
}
```

- [ ] **Step 3: Verify**

```bash
npm run lint && npm run build
```

Expected: pass. In dev mode: list populates from rproj, typing filters, `@workmbp` (or a real host alias) pins the host, Enter opens VS Code.

- [ ] **Step 4: Commit**

```bash
cd ~/src/personal/dotfiles
git add .config/raycast-extensions/toolbox/src/remote-projects.tsx .config/raycast-extensions/toolbox/package.json
git commit -m "raycast: add Open Remote Project command backed by rproj"
```

---

### Task 7: Documentation

**Files:**
- Rewrite: `.config/raycast-extensions/toolbox/README.md`
- Modify: `README.md` (repo root — add a Raycast section under "Repository Structure")

**Interfaces:** none (prose only).

- [ ] **Step 1: Rewrite the extension README**

Replace `.config/raycast-extensions/toolbox/README.md` covering:

- The four commands and their keyboard shortcuts (⌘[/⌘]/⌘T/⌘D/⌘J in Browse Meetings; `@host` syntax in Remote Projects).
- Install: `cd ~/.config/raycast-extensions/toolbox && npm install && npm run dev` once per machine; Raycast keeps the dev extension registered afterward. Remove the stale `meeting-notes` dev extension in Raycast (Extensions → right-click → Remove) if present.
- How Raycast config lives on disk: `~/.config/raycast/` (access token in `config.json`, installed extensions, AI data — never commit), `defaults com.raycast.macos` + internal database for settings/hotkeys; portability via Raycast Export/Import (`.rayconfig`) or Cloud Sync only.
- Manual replacements for retired Alfred workflows: 1Password store extension, built-in Toggle System Appearance, community Obsidian extension (optional), hotkey assignment steps.
- mtg dependency note: extension needs the enriched `mtg list --json` (this repo's `bin/mtg`), applied to `~/bin/mtg` via `yadm merge`.

- [ ] **Step 2: Add a Raycast section to the repo README**

Under "Repository Structure", add:

```markdown
### Raycast

Custom Raycast extension source lives in `~/.config/raycast-extensions/`
(see [toolbox/README.md](.config/raycast-extensions/toolbox/README.md)).
Raycast's own directory (`~/.config/raycast/`) contains credentials and
build artifacts and is intentionally untracked; app settings travel via
Raycast's Export/Import or Cloud Sync, not this repo.
```

- [ ] **Step 3: Commit**

```bash
cd ~/src/personal/dotfiles
git add .config/raycast-extensions/toolbox/README.md README.md
git commit -m "raycast: document toolbox extension and Raycast config boundaries"
```
