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
