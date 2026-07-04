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
