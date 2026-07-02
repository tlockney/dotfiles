/// <reference types="@raycast/api">

/* 🚧 🚧 🚧
 * This file is auto-generated from the extension's manifest.
 * Do not modify manually. Instead, update the `package.json` file.
 * 🚧 🚧 🚧 */

/* eslint-disable @typescript-eslint/ban-types */

type ExtensionPreferences = {
  /** mtg binary - Absolute path to the mtg CLI. Defaults to ~/bin/mtg. */
  "mtgPath": string,
  /** Calendar - Calendar to filter (passed to mtg --calendar). Comma-separated for multiple. */
  "calendar": string,
  /** Obsidian CLI - Absolute path to the obsidian CLI. */
  "obsidianPath": string,
  /** rproj binary - Absolute path to the rproj CLI. */
  "rprojPath": string
}

/** Preferences accessible in all the extension's commands */
declare type Preferences = ExtensionPreferences

declare namespace Preferences {
  /** Preferences accessible in the `browse-meetings` command */
  export type BrowseMeetings = ExtensionPreferences & {}
  /** Preferences accessible in the `quick-capture` command */
  export type QuickCapture = ExtensionPreferences & {}
  /** Preferences accessible in the `daily-note` command */
  export type DailyNote = ExtensionPreferences & {}
  /** Preferences accessible in the `remote-projects` command */
  export type RemoteProjects = ExtensionPreferences & {}
}

declare namespace Arguments {
  /** Arguments passed to the `browse-meetings` command */
  export type BrowseMeetings = {}
  /** Arguments passed to the `quick-capture` command */
  export type QuickCapture = {}
  /** Arguments passed to the `daily-note` command */
  export type DailyNote = {}
  /** Arguments passed to the `remote-projects` command */
  export type RemoteProjects = {}
}

