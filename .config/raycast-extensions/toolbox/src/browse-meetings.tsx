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
import { execFile } from "node:child_process";
import { homedir } from "node:os";
import { resolve } from "node:path";
import { promisify } from "node:util";
import { useMemo, useState } from "react";

const execFileAsync = promisify(execFile);

interface Preferences {
  mtgPath?: string;
  calendar?: string;
}

// Shape produced by `mtg list --json`. Real events have a `uid`; the empty-day
// placeholder doesn't, so we filter on that.
interface MtgJsonItem {
  uid?: string;
  title: string;
  subtitle: string;
  arg?: string;
  autocomplete?: string;
}

interface MtgJson {
  items: MtgJsonItem[];
}

function expandTilde(input: string): string {
  if (input === "~") return homedir();
  if (input.startsWith("~/")) return resolve(homedir(), input.slice(2));
  return input;
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

// mtg's subtitle has the shape "HH:MM - HH:MM • N invitees". Split it so
// time gets its own accessory and the invitee count gets a person icon —
// reads more like a calendar than a single grey blob.
function splitSubtitle(subtitle: string): { time?: string; invitees?: string } {
  const [timePart, inviteePart] = subtitle.split(" • ");
  return { time: timePart?.trim(), invitees: inviteePart?.trim() };
}

export default function Command() {
  const prefs = getPreferenceValues<Preferences>();
  const mtgPath = useMemo(
    () => expandTilde((prefs.mtgPath ?? "").trim() || "~/bin/mtg"),
    [prefs.mtgPath],
  );
  const calendar = (prefs.calendar ?? "").trim() || "Work Calendar";

  const [date, setDate] = useState<Date>(() => new Date());
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

  const meetings = (data?.items ?? []).filter((i): i is Required<MtgJsonItem> =>
    Boolean(i.uid),
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
    } catch (err) {
      toast.style = Toast.Style.Failure;
      toast.title = "Failed to create note";
      toast.message = err instanceof Error ? err.message : String(err);
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
      navigationTitle={navigationTitle}
      searchBarPlaceholder={`Filter meetings on ${dateStr}…`}
    >
      {error ? (
        <List.EmptyView
          icon={Icon.ExclamationMark}
          title="mtg failed"
          description={error instanceof Error ? error.message : String(error)}
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
          const { time, invitees } = splitSubtitle(item.subtitle);
          return (
            <List.Item
              key={item.uid}
              icon={Icon.Calendar}
              title={item.title}
              accessories={[
                time ? { tag: time, icon: Icon.Clock } : {},
                invitees ? { text: invitees, icon: Icon.Person } : {},
              ]}
              actions={
                <ActionPanel>
                  <Action
                    title="Create Meeting Note"
                    icon={Icon.Document}
                    onAction={() => createNote(item.uid, item.title)}
                  />
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
