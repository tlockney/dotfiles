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
