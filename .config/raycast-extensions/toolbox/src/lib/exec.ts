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
