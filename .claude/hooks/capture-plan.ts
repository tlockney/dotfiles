#!/usr/bin/env -S deno run --allow-read --allow-write --allow-run --allow-env

// capture-plan.ts — Claude Code Hook for ExitPlanMode

const DEBUG_LOG = "/tmp/capture-plan-debug.log";
const enc = new TextEncoder();
const dec = new TextDecoder();

async function log(...lines: string[]): Promise<void> {
  await Deno.writeTextFile(DEBUG_LOG, lines.join("\n") + "\n", { append: true });
}

async function run(
  exe: string,
  args: string[],
  stdinText?: string,
): Promise<{ stdout: string; success: boolean }> {
  const cmd = new Deno.Command(exe, {
    args,
    stdin: stdinText !== undefined ? "piped" : "null",
    stdout: "piped",
    stderr: "null",
  });

  if (stdinText !== undefined) {
    const proc = cmd.spawn();
    const writer = proc.stdin.getWriter();
    await writer.write(enc.encode(stdinText));
    await writer.close();
    const [stdout, { success }] = await Promise.all([
      new Response(proc.stdout).text(),
      proc.status,
    ]);
    return { stdout, success };
  }

  const { stdout, success } = await cmd.output();
  return { stdout: dec.decode(stdout), success };
}

// --- Read stdin ---
const input = await new Response(Deno.stdin.readable).text();
await log(`=== ${new Date()} ===`, input, "---");

let parsed: Record<string, unknown>;
try {
  parsed = JSON.parse(input);
} catch {
  Deno.exit(0);
}

const toolName = (parsed.tool_name as string) ?? "";
const hookEvent = (parsed.hook_event_name as string) ?? "";
const sessionId = (parsed.session_id as string) ?? "unknown";

const toolResponse = parsed.tool_response as Record<string, unknown> | undefined;
const toolInput = parsed.tool_input as Record<string, unknown> | undefined;

const tryFile = async (path: unknown): Promise<string> => {
  if (typeof path === "string" && path && path !== "null") {
    try { return await Deno.readTextFile(path); } catch { /* ignore */ }
  }
  return "";
};

const tryInline = (val: unknown): string =>
  typeof val === "string" && val && val !== "null" ? val : "";

// Superpowers plans are written via `Write` and skip ExitPlanMode entirely.
// Canonical location is docs/superpowers/plans/*.md, but the skill explicitly
// defers to user-preferred locations — so we also accept any .md under a
// docs/ subtree whose content carries a superpowers plan marker.
const SUPERPOWERS_PLAN_MARKER = /^>\s*\*\*For agentic workers:\*\*/m;

function isSuperpowersPlanWrite(): boolean {
  if (toolName !== "Write") return false;
  const fp = String(toolInput?.file_path ?? "");
  if (!fp.endsWith(".md")) return false;
  if (/\/superpowers\/plans\/[^/]+\.md$/.test(fp)) return true;
  if (!/\/docs\//.test(fp)) return false;
  const content = tryInline(toolInput?.content);
  return !!content && SUPERPOWERS_PLAN_MARKER.test(content);
}

const isExitPlan = toolName === "ExitPlanMode";
const isSpPlan = isSuperpowersPlanWrite();

if (!isExitPlan && !isSpPlan) Deno.exit(0);

// --- Extract plan content ---
let planContent = "";
let planFile = "";
let planSource = "unknown";
let preferredFilename = ""; // Non-empty when we want to bypass slug derivation.

if (isSpPlan) {
  planFile = String(toolInput?.file_path ?? "");
  planContent = tryInline(toolInput?.content) || await tryFile(planFile);
  planSource = "superpowers.write";
  // Plan basename already carries a date + feature-name slug, reuse it verbatim
  // so re-writes overwrite the same Obsidian note instead of spawning duplicates.
  preferredFilename = planFile.split("/").pop()?.replace(/\.md$/i, "") ?? "";
} else if ((planContent = tryInline(toolResponse?.plan))) {
  planSource = "tool_response.plan";
} else if ((planContent = await tryFile((planFile = String(toolResponse?.filePath ?? ""))))) {
  planSource = "tool_response.filePath";
} else if ((planContent = tryInline(toolInput?.plan))) {
  planSource = "tool_input.plan";
} else if ((planContent = await tryFile((planFile = String(toolInput?.planFilePath ?? ""))))) {
  planSource = "tool_input.planFilePath";
}

if (!planContent || planContent.length < 20) {
  await log("No valid plan content found", `HOOK_EVENT=${hookEvent}`, `TOOL=${toolName}`, `PLAN_SOURCE=${planSource}`, `PLAN_FILE=${planFile}`);
  Deno.exit(0);
}

// --- Extract title + slug + date metadata ---
function extractMeta(content: string) {
  const STOP_WORDS = new Set(["a", "an", "the", "with", "and", "of", "for", "to"]);
  const now = new Date();
  const pad = (n: number) => String(n).padStart(2, "0");

  let title = "Unnamed Plan";
  for (const raw of content.split("\n")) {
    let line = raw.trim();
    if (!line) continue;
    line = line.replace(/^#+\s*/, "").replace(/^plan:\s*/i, "").replace(/\s+/g, " ").trim();
    if (line) { title = line; break; }
  }
  title = title.replace(/[`*_]/g, "").replace(/\s+/g, " ").trim() || "Unnamed Plan";

  let slug = title.toLowerCase()
    .replace(/&/g, " and ")
    .replace(/[^a-z0-9\s-]/g, "")
    .replace(/\s+/g, "-")
    .replace(/-+/g, "-")
    .replace(/^-|-$/g, "");

  const words = slug.split("-").filter(Boolean);
  if (words.length > 6) {
    const filtered = words.filter((w, i) =>
      !(STOP_WORDS.has(w) && i !== 0 && i !== words.length - 1)
    );
    slug = filtered.join("-") || slug;
  }

  if (slug.length > 80) {
    const parts = slug.split("-");
    const kept: string[] = [];
    let total = 0;
    for (const part of parts) {
      const extra = part.length + (kept.length ? 1 : 0);
      if (total + extra > 80) break;
      kept.push(part);
      total += extra;
    }
    slug = kept.join("-") || slug;
  }

  const datePrefix = `${pad(now.getDate())}-${pad(now.getMonth() + 1)}-${now.getFullYear()}`;
  const monthName = now.toLocaleString("en-US", { month: "long" });

  return {
    planTitle: title,
    planSlug: slug || "unnamed-plan",
    datePrefix,
    year: String(now.getFullYear()),
    monthDir: `${pad(now.getMonth() + 1)}-${monthName}`,
  };
}

const { planTitle, planSlug, datePrefix } = extractMeta(planContent);
// Superpowers plan basenames already include the date + slug; reuse them so
// that re-writing a plan during the review loop updates the same note.
const planFilename = preferredFilename || `${datePrefix}-${planSlug}`;
const planPath = `Active/Metron/Plans/${planFilename}`;

// Ask Obsidian where today's daily note actually lives — the vault's daily-note
// template owns the date format, so we can't safely hardcode one here.
const { stdout: rawDailyPath, success: gotDailyPath } = await run("obsidian", ["daily:path"]);
const dailyPath = gotDailyPath ? rawDailyPath.trim() : "";
const journalLink = dailyPath.replace(/\.md$/i, "");

await log(
  `HOOK_EVENT=${hookEvent}`, `PLAN_SOURCE=${planSource}`, `PLAN_FILE=${planFile}`,
  `PLAN_TITLE=${planTitle}`, `PLAN_SLUG=${planSlug}`, `PLAN_FILENAME=${planFilename}`,
);

// --- Summary + tags via Claude CLI ---
let summary = "";
let newTags = "";

try {
  const result = await run("claude", [
    "-p", "--bare", "--max-turns", "1",
    "--model", "claude-haiku-4-5-20251001",
    "--output-format", "text",
    "--system-prompt",
    `You are a concise note-taking assistant. Given an engineering plan, output exactly two lines:
Line 1: A 1-2 sentence summary (max 200 chars). Be specific about what will be built or changed.
Line 2: 1-2 lowercase kebab-case tags relevant to the plan topic (comma-separated, no # prefix).
Output ONLY these two lines.`,
    "Summarise and tag this plan:",
  ], planContent);

  if (result.success) {
    const lines = result.stdout.trim().split("\n");
    summary = lines[0]?.trim() ?? "";
    newTags = lines.at(-1)?.trim() ?? "";
  }
} catch { /* ignore */ }

// Fallback summary
if (!summary || summary.length > 300) {
  let text = planContent
    .replace(/```[\s\S]*?```/g, " ")
    .replace(/^#+\s*/gm, "")
    .replace(/^\|.*\|$/gm, " ")
    .replace(/^\s*[-*]\s+/gm, "")
    .replace(/^(Plan:|PLAN:)\s*/gm, "")
    .replace(/\s+/g, " ")
    .trim();

  const m = text.match(
    /Context\s+([\s\S]*?)(?:Approach|Architecture Decisions|Project Structure|Routing|Data Storage|Implementation Steps|Verification|$)/i,
  );
  if (m) text = m[1].trim();

  text = text.slice(0, 200).trimEnd();
  summary = text ? (text.length === 200 ? text + "..." : text) : "Captured an engineering plan from Claude Code.";
}

if (!newTags) newTags = "engineering-plan";
summary = summary.replace(/\n/g, " ").trim();

// --- Build note ---
const noteContent = `---
created: ${datePrefix}
status: planned
tags:
  - plan
  - claude-session
source: Claude Code (Plan Mode)
session: ${sessionId}
hook_event: ${hookEvent}
source_type: ${planSource}
source_file: ${planFile}
---

# ${planTitle}

## Logged In
[[${journalLink}]]

## Plan

${planContent}
`;

// --- Write to Obsidian ---
const created = await run("obsidian", ["create", `path=${planPath}`, `content=${noteContent}`, "silent"]);
if (!created.success) {
  await log("Failed to create plan note");
  Deno.exit(0);
}

const journalEntry = `- [[${planPath}|${planTitle}]] (planned)\n  - ${summary}`;

await run("obsidian", ["daily:append", `content=${journalEntry}`]);

// Merge tags onto daily note
if (dailyPath) {
  const path = dailyPath;
  const { stdout: existingRaw, success: gotTags } = await run("obsidian", ["property:read", "name=tags", `path=${path}`]);
  if (gotTags) {
    const existing = existingRaw.split("\n").map((t) => t.trim()).filter(Boolean);
    const incoming = newTags.split(",").map((t) => t.trim()).filter(Boolean);
    const merged = [...new Set([...existing, ...incoming])].join(",");
    if (merged) {
      await run("obsidian", ["property:set", "name=tags", `value=${merged}`, "type=list", `path=${path}`]);
    }
  }
}