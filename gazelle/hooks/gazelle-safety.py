#!/usr/bin/env python3
"""
Gazelle Safety Hook — warns when editing sensitive Gazelle files.

Based on Anthropic's security-guidance hook pattern.
Installs as a PreToolUse hook for Edit, Write, MultiEdit tools.

Warns (but doesn't block) when:
- Editing context-training files (could affect all skills)
- Deleting project state files (could lose research data)
- Editing another project's state
"""

import json
import os
import sys
from datetime import datetime

# Files that log to
DEBUG_LOG = "/tmp/gazelle-safety-log.txt"

# Patterns that trigger warnings
SENSITIVE_PATTERNS = [
    {
        "name": "context_training_edit",
        "check": lambda path, _: "context-training/" in path and path.endswith(".md"),
        "message": """⚠️ **Editing Gazelle context-training file**

This file affects ALL Gazelle skills across ALL projects.
- Changes here change how every skill behaves
- Consider if this change should be in a project-specific file instead
- If intentional, ensure it doesn't break existing skill behavior

Proceeding — but please verify the change is correct.""",
    },
    {
        "name": "state_deletion",
        "check": lambda path, content: ".state/projects/" in path
        and content
        and ("delete" in content.lower() or "remove" in content.lower() or content.strip() == ""),
        "message": """⚠️ **Potentially destructive edit to Gazelle project state**

This file contains research data, insights, or project artifacts.
- Deleting state files can lose hours of research work
- Consider archiving instead of deleting
- If the file is truly stale, verify no other skills reference it

Proceeding — but please confirm this is intentional.""",
    },
    {
        "name": "inline_context_edit",
        "check": lambda path, _: "inline-domain-context.md" in path
        or "inline-design-context.md" in path,
        "message": """⚠️ **Editing inline context template**

This file is the source template that gets inlined into ALL skill files.
Changes here won't take effect until skills are re-inlined.
- Edit the template, then re-run the inline process
- Or edit individual skill appendices directly

Proceeding — remember to sync inline context to skills.""",
    },
]


def debug_log(message):
    try:
        with open(DEBUG_LOG, "a") as f:
            ts = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
            f.write(f"[{ts}] {message}\n")
    except Exception:
        pass


def extract_content(tool_name, tool_input):
    if tool_name == "Write":
        return tool_input.get("content", "")
    elif tool_name == "Edit":
        return tool_input.get("new_string", "")
    elif tool_name == "MultiEdit":
        edits = tool_input.get("edits", [])
        return " ".join(e.get("new_string", "") for e in edits) if edits else ""
    return ""


def main():
    try:
        raw_input = sys.stdin.read()
        data = json.loads(raw_input)
    except json.JSONDecodeError:
        sys.exit(0)

    tool_name = data.get("tool_name", "")
    tool_input = data.get("tool_input", {})

    if tool_name not in ["Edit", "Write", "MultiEdit"]:
        sys.exit(0)

    file_path = tool_input.get("file_path", "")
    if not file_path:
        sys.exit(0)

    content = extract_content(tool_name, tool_input)

    for pattern in SENSITIVE_PATTERNS:
        try:
            if pattern["check"](file_path, content):
                debug_log(f"Triggered: {pattern['name']} on {file_path}")
                # Print warning to stderr (shown to Claude) but exit 0 (allow)
                print(pattern["message"], file=sys.stderr)
                sys.exit(0)  # Allow but warn (exit 0 = proceed, exit 2 = block)
        except Exception as e:
            debug_log(f"Error in pattern {pattern['name']}: {e}")
            continue

    sys.exit(0)


if __name__ == "__main__":
    main()
