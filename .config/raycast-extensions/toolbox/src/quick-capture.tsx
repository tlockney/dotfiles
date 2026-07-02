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
      await showToast({
        style: Toast.Style.Failure,
        title: "Nothing to capture",
      });
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
