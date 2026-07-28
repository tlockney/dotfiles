#!/usr/bin/env python3
"""Validate a JSON file, tolerating the JSONC that some editors emit.

VS Code's settings.json and keybindings.json legitimately contain // and /*
*/ comments and trailing commas. A strict json.load rejects those, so the
choice is between skipping those files entirely or parsing what they
actually are. This does the latter: strip comments and trailing commas, then
parse. Anything that still fails is a real syntax error.
"""

import json
import re
import sys

# Matches a double-quoted JSON string, or a // or /* */ comment. Alternating
# on the string case first means a // inside a string value is left alone.
_TOKENS = re.compile(
    r'"(?:\\.|[^"\\])*"'      # string literal, escapes included
    r"|//[^\n]*"              # line comment
    r"|/\*.*?\*/",            # block comment
    re.DOTALL,
)

_TRAILING_COMMA = re.compile(r",(\s*[}\]])")


def strip_jsonc(text: str) -> str:
    def replace(match: re.Match) -> str:
        token = match.group(0)
        # Keep strings verbatim; replace comments with equivalent whitespace
        # so that reported line numbers still line up with the source.
        if token.startswith('"'):
            return token
        return re.sub(r"\S", " ", token)

    return _TRAILING_COMMA.sub(r"\1", _TOKENS.sub(replace, text))


def main() -> int:
    if len(sys.argv) != 2:
        print("usage: check-json.py <file>", file=sys.stderr)
        return 2

    path = sys.argv[1]
    with open(path, encoding="utf-8") as handle:
        text = handle.read()

    try:
        json.loads(text)
        return 0
    except json.JSONDecodeError:
        pass

    # Strict parsing failed. That is expected for a JSONC file -- the strict
    # error just points at the first comment -- so re-parse with comments
    # blanked out and report *that* error, whose line numbers still refer to
    # the file as written because comments are replaced by equal-length
    # whitespace rather than removed.
    try:
        json.loads(strip_jsonc(text))
    except json.JSONDecodeError as error:
        print(f"line {error.lineno}: {error.msg}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
