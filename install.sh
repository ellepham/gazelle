#!/usr/bin/env bash
set -euo pipefail

# Gazelle Toolkit Installer
# Installs Gazelle skills, agents, and commands into Cursor, Claude Code, and/or Cowork

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET=""
IDE="both"
FORCE=false
LINK=false
FULL_PATH=""

usage() {
  cat <<'EOF'
Usage: ./install.sh [options]

Options:
  --cursor              Install for Cursor only
  --claude              Install for Claude Code only
  --cowork              Package as Cowork plugin (.zip file)
  --both                Install for Cursor + Claude Code (default)
  --all                 Install for Cursor + Claude Code + Cowork
  --target PATH         Target workspace (default: current directory)
  --force               Overwrite existing files
  --link                Symlink instead of copy (auto-updates via git pull)
  --full PATH           Use custom context-training files from local path
  -h, --help            Show this help

Examples:
  ./install.sh                              # Cursor + Claude Code, current dir
  ./install.sh --cursor --target ~/myproj   # Cursor only, specific dir
  ./install.sh --link --target ~/myproj     # Symlink mode (updates via git pull)
  ./install.sh --cowork                     # Package as gazelle.zip
  ./install.sh --all --target ~/myproj      # All 3 targets
  ./install.sh --full ~/private/context     # Use unredacted files
EOF
  exit 0
}

while [[ $# -gt 0 ]]; do
  case $1 in
    --cursor) IDE="cursor"; shift ;;
    --claude) IDE="claude"; shift ;;
    --cowork) IDE="cowork"; shift ;;
    --both) IDE="both"; shift ;;
    --all) IDE="all"; shift ;;
    --target) TARGET="$2"; shift 2 ;;
    --force) FORCE=true; shift ;;
    --link) LINK=true; shift ;;
    --full) FULL_PATH="$2"; shift 2 ;;
    -h|--help) usage ;;
    *) echo "Unknown option: $1"; usage ;;
  esac
done

TARGET="${TARGET:-.}"
TARGET="$(cd "$TARGET" && pwd)"
PLUGIN_ROOT="$SCRIPT_DIR/gazelle"

copied=0
skipped=0
generated=0
linked=0

copy_file() {
  local src="$1" dst="$2"
  if [[ -e "$dst" ]] && [[ "$FORCE" != true ]] && [[ "$LINK" != true ]]; then
    skipped=$((skipped + 1))
    return
  fi
  mkdir -p "$(dirname "$dst")"
  if [[ "$LINK" == true ]]; then
    ln -sf "$src" "$dst"
    linked=$((linked + 1))
  else
    cp "$src" "$dst"
    copied=$((copied + 1))
  fi
}

copy_dir() {
  local src="$1" dst="$2"
  if [[ "$LINK" == true ]]; then
    mkdir -p "$(dirname "$dst")"
    # Remove existing dir/symlink so ln -sfn works cleanly
    rm -rf "$dst"
    ln -sfn "$src" "$dst"
    linked=$((linked + 1))
  else
    if [[ -d "$dst" ]] && [[ "$FORCE" != true ]]; then
      skipped=$((skipped + 1))
      return
    fi
    mkdir -p "$dst"
    cp -R "$src"/* "$dst"/
    copied=$((copied + 1))
  fi
}

# Command wrapper templates
generate_cursor_command() {
  local name="$1" desc="$2" skill_path="$3"
  local dst="$TARGET/.cursor/commands/${name}.md"
  if [[ -e "$dst" ]] && [[ "$FORCE" != true ]]; then
    skipped=$((skipped + 1))
    return
  fi
  mkdir -p "$(dirname "$dst")"
  cat > "$dst" <<CMDEOF
# /${name}

${desc}

---

## Skill

Read and follow: \`.cursor/skills/${skill_path}\`
CMDEOF
  generated=$((generated + 1))
}

generate_claude_command() {
  local name="$1" desc="$2" skill_path="$3"
  local dst="$TARGET/.claude/commands/${name}.md"
  if [[ -e "$dst" ]] && [[ "$FORCE" != true ]]; then
    skipped=$((skipped + 1))
    return
  fi
  mkdir -p "$(dirname "$dst")"
  cat > "$dst" <<CMDEOF
---
description: "${desc}"
argument-hint: "[topic or feature name]"
---

# /${name}

${desc}

Topic/arguments: \$ARGUMENTS

---

## Skill

Read and follow: \`.claude/skills/${skill_path}\`
CMDEOF
  generated=$((generated + 1))
}

# Gazelle discover needs a special command (references multiple skills)
generate_cursor_discover() {
  local dst="$TARGET/.cursor/commands/gazelle-discover.md"
  if [[ -e "$dst" ]] && [[ "$FORCE" != true ]]; then
    skipped=$((skipped + 1))
    return
  fi
  mkdir -p "$(dirname "$dst")"
  cat > "$dst" <<'CMDEOF'
# /gazelle-discover

Full discovery sprint — chains research → insights → personas → journey → spec → critique with checkpoints between each phase.

---

## Usage

```
/gazelle-discover [topic]
/gazelle-discover [topic] --skip research
/gazelle-discover [topic] --until personas
/gazelle-discover [topic] --capture
```

---

## Skill

Read and follow the **Discovery Sprint Protocol** section in: `.cursor/skills/gazelle/SKILL.md`

For each phase, load and follow the corresponding skill:
- Research: `.cursor/skills/research/SKILL.md`
- Insights: `.cursor/skills/insights/SKILL.md`
- Personas: `.cursor/skills/persona-builder/SKILL.md`
- Flow Capture: `.cursor/skills/flow-capture/SKILL.md` (only with `--capture`)
- Journey: `.cursor/skills/journey-mapping/SKILL.md`
- Spec: `.cursor/skills/design-spec/SKILL.md`
- Critique: `.cursor/skills/design-critique/SKILL.md`
CMDEOF
  generated=$((generated + 1))
}

generate_claude_discover() {
  local dst="$TARGET/.claude/commands/discover.md"
  if [[ -e "$dst" ]] && [[ "$FORCE" != true ]]; then
    skipped=$((skipped + 1))
    return
  fi
  mkdir -p "$(dirname "$dst")"
  cat > "$dst" <<'CMDEOF'
---
description: "Full discovery sprint — chains research → insights → personas → journey → spec → critique"
argument-hint: "[topic] [--skip phase] [--until phase] [--capture]"
---

# /discover

Full discovery sprint — chains research → insights → personas → journey → spec → critique with checkpoints between each phase.

Topic/arguments: $ARGUMENTS

---

## Skill

Read and follow the **Discovery Sprint Protocol** section in: `.claude/skills/gazelle/SKILL.md`

For each phase, load and follow the corresponding skill:
- Research: `.claude/skills/research/SKILL.md`
- Insights: `.claude/skills/insights/SKILL.md`
- Personas: `.claude/skills/persona-builder/SKILL.md`
- Flow Capture: `.claude/skills/flow-capture/SKILL.md` (only with `--capture`)
- Journey: `.claude/skills/journey-mapping/SKILL.md`
- Spec: `.claude/skills/design-spec/SKILL.md`
- Critique: `.claude/skills/design-critique/SKILL.md`
CMDEOF
  generated=$((generated + 1))
}

# Gazelle hub command (no topic arg)
generate_cursor_hub() {
  local dst="$TARGET/.cursor/commands/gazelle.md"
  if [[ -e "$dst" ]] && [[ "$FORCE" != true ]]; then
    skipped=$((skipped + 1))
    return
  fi
  mkdir -p "$(dirname "$dst")"
  cat > "$dst" <<'CMDEOF'
# /gazelle

Product design & service design agent. Entry point for all Gazelle commands.

---

## Usage

```
/gazelle                     # Show available commands + active projects
/gazelle status              # Show state of all active projects
/gazelle status [project]    # Show state of specific project
```

---

## Skill

Read and follow: `.cursor/skills/gazelle/SKILL.md`
CMDEOF
  generated=$((generated + 1))
}

generate_claude_hub() {
  local dst="$TARGET/.claude/commands/gazelle.md"
  if [[ -e "$dst" ]] && [[ "$FORCE" != true ]]; then
    skipped=$((skipped + 1))
    return
  fi
  mkdir -p "$(dirname "$dst")"
  cat > "$dst" <<'CMDEOF'
---
description: "Product design & service design agent. Entry point for all Gazelle commands."
argument-hint: "[status] [project-name]"
---

# /gazelle

Product design & service design agent. Entry point for all Gazelle commands.

Arguments: $ARGUMENTS

---

## Skill

Read and follow: `.claude/skills/gazelle/SKILL.md`
CMDEOF
  generated=$((generated + 1))
}

install_for_ide() {
  local ide="$1"
  local ide_dir=".$ide"

  echo ""
  echo "=== Installing for $ide ==="
  echo "  Target: $TARGET/$ide_dir/"
  echo ""

  # Skills (all dirs under skills/)
  for skill_dir in "$PLUGIN_ROOT"/skills/*/; do
    local skill_name
    skill_name="$(basename "$skill_dir")"
    copy_dir "$skill_dir" "$TARGET/$ide_dir/skills/$skill_name"
    echo "  [skill] $skill_name"
  done

  # Agents
  for agent_file in "$PLUGIN_ROOT"/agents/*.md; do
    local agent_name
    agent_name="$(basename "$agent_file")"
    copy_file "$agent_file" "$TARGET/$ide_dir/agents/$agent_name"
    echo "  [agent] $agent_name"
  done

  # Hooks (if they exist)
  if [[ -d "$PLUGIN_ROOT/hooks" ]]; then
    for hook_file in "$PLUGIN_ROOT"/hooks/*; do
      local hook_name
      hook_name="$(basename "$hook_file")"
      copy_file "$hook_file" "$TARGET/$ide_dir/hooks/$hook_name"
      echo "  [hook]  $hook_name"
    done
  fi

  # Commands (Claude Code only — Cursor uses skills directly)
  if [[ "$ide" == "claude" ]]; then
    local skills=(
      # Research & Analysis
      "research|Multi-source research with evidence ledger|research/SKILL.md"
      "insights|Synthesize research into insights + HMW questions|insights/SKILL.md"
      "competitive-analysis|Competitive intelligence: internal signals + external research|competitive-analysis/SKILL.md"
      "opportunity-sizing|Evidence-backed opportunity scoring with usage data|opportunity-sizing/SKILL.md"
      "feedback-synthesizer|Periodic feedback synthesis across sources|feedback-synthesizer/SKILL.md"
      # Design & Prototyping
      "explore-designs|Generate 2-3 hi-fi design concepts in Figma from a spec|explore-designs/SKILL.md"
      "design-spec|Write design spec from accumulated state|design-spec/SKILL.md"
      "design-critique|Review design against your design principles + project state|design-critique/SKILL.md"
      "wireframe|Create wireframes in Figma or Pencil|wireframe/SKILL.md"
      "prototype|Build clickable HTML prototype from live app|prototype/SKILL.md"
      # Figma Design Tools
      "figma-use|Direct Figma canvas operations (frames, colors, auto-layout)|figma-use/SKILL.md"
      "figma-implement-design|Translate Figma design to production code|figma-implement-design/SKILL.md"
      "figma-generate-design|Capture web page and recreate in Figma|figma-generate-design/SKILL.md"
      "figma-generate-library|Build or update design system libraries in Figma|figma-generate-library/SKILL.md"
      "figma-code-connect-components|Map Figma components to codebase via Code Connect|figma-code-connect-components/SKILL.md"
      "figma-create-design-system-rules|Generate project-specific design system rules|figma-create-design-system-rules/SKILL.md"
      "figma-create-new-file|Create new blank Figma file|figma-create-new-file/SKILL.md"
      "figma-researcher|Extract design specs, tokens, spacing from Figma|figma-researcher/SKILL.md"
      "figma-image-downloader|Download Figma frames as PNG or PDF|figma-image-downloader/SKILL.md"
      # Strategy & Decision Tools
      "idea-check|Product diagnostic with 6 forcing questions|idea-check/SKILL.md"
      "strategy-review|Strategic plan review (expand, hold, or reduce scope)|strategy-review/SKILL.md"
      "pre-mortem|Risk assessment before launch (Tigers, Paper Tigers, Elephants)|pre-mortem/SKILL.md"
      "experiment-design|A/B test design with hypothesis, metrics, sample size|experiment-design/SKILL.md"
      "yes-and|Constructive idea expansion: bigger version + defuse landmines|yes-and/SKILL.md"
      "jtbd|Jobs to Be Done: functional, social, emotional + prioritization|jtbd/SKILL.md"
      "working-backwards|Amazon-style PR/FAQ with 5 assessment tests|working-backwards/SKILL.md"
      # People & Journeys
      "persona-builder|Build, refresh, or test data-grounded personas|persona-builder/SKILL.md"
      "journey-mapping|Map user journey from data + interviews|journey-mapping/SKILL.md"
      "flow-capture|Navigate live app, screenshot each step, document current flow|flow-capture/SKILL.md"
      # Deliverables & Utility
      "create-deliverable|Voice cards, debates, critic reviews, decision matrices, 1-pagers|create-deliverable/SKILL.md"
      "acceptance-criteria|Hills-format ACs + Given/When/Then + QA checklist|acceptance-criteria/SKILL.md"
      "skillify|Turn a workflow into a reusable Gazelle skill|skillify/SKILL.md"
      # Setup
      "setup|Configure Gazelle for your company — generates context-training files|setup/SKILL.md"
      "quick-start|Guided onboarding by role|quick-start/SKILL.md"
      "setup-cursor|First-time Gazelle setup in Cursor: install + MCP config|setup-cursor/SKILL.md"
      "setup-cowork|First-time Gazelle setup in Cowork: install + connectors|setup-cowork/SKILL.md"
      "setup-code-cli|First-time Gazelle setup in Claude Code: install + .claude/settings.yml MCP|setup-code-cli/SKILL.md"
    )

    for entry in "${skills[@]}"; do
      IFS='|' read -r name desc path <<< "$entry"
      generate_claude_command "$name" "$desc" "$path"
      echo "  [cmd]   $name"
    done

    generate_claude_hub
    generate_claude_discover
    echo "  [cmd]   gazelle"
    echo "  [cmd]   discover"
  fi

  echo ""
}

# Context training
install_context() {
  echo "=== Installing context-training ==="
  local ctx_src="$SCRIPT_DIR/context-training"
  local ctx_dst="$TARGET/projects/gazelle-agent/context-training"

  if [[ -n "$FULL_PATH" ]]; then
    ctx_src="$FULL_PATH"
    echo "  Using custom context files from: $FULL_PATH"
  else
    echo "  Using default context templates. Pass --full for custom context files."
  fi

  mkdir -p "$ctx_dst"
  for f in "$ctx_src"/*.md; do
    local fname
    fname="$(basename "$f")"
    copy_file "$f" "$ctx_dst/$fname"
    echo "  [ctx]   $fname"
  done
  echo ""
}

# State directory
install_state() {
  mkdir -p "$TARGET/projects/gazelle-agent/.state/projects"
  echo "=== Created project state directory ==="
  echo "  $TARGET/projects/gazelle-agent/.state/projects/"
  echo ""
}

# Cowork plugin packaging
install_cowork() {
  echo ""
  echo "=== Packaging Cowork plugin ==="

  local tmp_dir
  tmp_dir="$(mktemp -d)"
  local plugin_dir="$tmp_dir/gazelle"

  mkdir -p "$plugin_dir"

  # Plugin manifest
  cp -R "$PLUGIN_ROOT/.claude-plugin" "$plugin_dir/.claude-plugin"

  # Skills (with context-training as references inside the orchestrator skill)
  cp -R "$PLUGIN_ROOT/skills" "$plugin_dir/skills"

  local ctx_src="$SCRIPT_DIR/context-training"
  if [[ -n "$FULL_PATH" ]]; then
    ctx_src="$FULL_PATH"
    echo "  Using custom context-training from: $FULL_PATH"
  fi
  mkdir -p "$plugin_dir/skills/gazelle/references"
  for f in "$ctx_src"/*.md; do
    cp "$f" "$plugin_dir/skills/gazelle/references/"
  done
  echo "  [skill] context-training → skills/gazelle/references/"

  # Agents
  cp -R "$PLUGIN_ROOT/agents" "$plugin_dir/agents"
  echo "  [agent] copied all agents"

  # Hooks (if they exist)
  if [[ -d "$PLUGIN_ROOT/hooks" ]]; then
    cp -R "$PLUGIN_ROOT/hooks" "$plugin_dir/hooks"
    echo "  [hook]  copied all hooks"
  fi

  # No commands for Cowork — skills are the interface (avoids duplicate entries)

  # README
  cp "$PLUGIN_ROOT/README.md" "$plugin_dir/README.md"

  # Package as .zip (Cowork only accepts .zip for drag-and-drop upload)
  local plugin_file="$TARGET/gazelle.zip"
  if [[ -e "$plugin_file" ]] && [[ "$FORCE" != true ]]; then
    echo "  gazelle.zip already exists. Use --force to overwrite."
    skipped=$((skipped + 1))
  else
    (cd "$plugin_dir" && zip -r /tmp/gazelle.zip . -x "*.DS_Store" > /dev/null 2>&1)
    cp /tmp/gazelle.zip "$plugin_file"
    rm -f /tmp/gazelle.zip
    echo "  [plugin] gazelle.zip → $plugin_file"
    copied=$((copied + 1))
  fi

  # Cleanup
  rm -rf "$tmp_dir"

  echo ""
  echo "  Install in Cowork: open Claude Desktop → drag gazelle.zip into a Cowork session"
  echo "  Or: Customize → Personal plugins → + → Upload → browse for gazelle.zip"
  echo ""
}

echo ""
echo "╔══════════════════════════════════════╗"
echo "║     Gazelle Toolkit Installer        ║"
echo "╚══════════════════════════════════════╝"
echo ""
echo "Source: $SCRIPT_DIR"
echo "Target: $TARGET"
echo "IDE:    $IDE"
echo "Mode:   $(if [[ "$LINK" == true ]]; then echo "symlink"; else echo "copy"; fi)"
echo "Force:  $FORCE"

if [[ "$IDE" == "cursor" ]] || [[ "$IDE" == "both" ]] || [[ "$IDE" == "all" ]]; then
  install_for_ide "cursor"
fi

if [[ "$IDE" == "claude" ]] || [[ "$IDE" == "both" ]] || [[ "$IDE" == "all" ]]; then
  install_for_ide "claude"
fi

if [[ "$IDE" == "cowork" ]] || [[ "$IDE" == "all" ]]; then
  install_cowork
fi

if [[ "$IDE" != "cowork" ]]; then
  install_context
  install_state
fi

echo "=== Summary ==="
if [[ "$LINK" == true ]]; then
echo "  Linked:    $linked (symlinks — updates via git pull)"
else
echo "  Copied:    $copied"
fi
echo "  Generated: $generated (command wrappers)"
echo "  Skipped:   $skipped (already exist, use --force to overwrite)"
echo ""

if [[ "$LINK" == true ]]; then
echo "=== Update ==="
echo "  Symlink mode: just run 'git pull' in the gazelle-toolkit repo."
echo "  Skills, agents, and context-training update automatically."
echo "  Command wrappers are generated — re-run installer to pick up new commands."
echo ""
fi

echo "=== MCP Prerequisites ==="
echo ""
echo "  Required for core features:"
echo "    - Notion MCP     (research, insights, personas)"
echo "    - Slack MCP       (research, insights)"
echo "    - Circleback MCP  (meeting transcript search)"
echo ""
echo "  Recommended:"
echo "    - Omni MCP        (BigQuery — analyst subagent, persona validation)"
echo "    - Figma MCP       (design review, critique)"
echo "    - Pencil MCP      (wireframing, design review)"
echo ""
echo "  Optional:"
echo "    - Google Drive MCP (research enrichment)"
if [[ "$IDE" == "cursor" ]] || [[ "$IDE" == "both" ]] || [[ "$IDE" == "all" ]]; then
echo "    - cursor-ide-browser (flow capture — Cursor built-in)"
fi
if [[ "$IDE" == "claude" ]] || [[ "$IDE" == "both" ]] || [[ "$IDE" == "all" ]]; then
echo "    - Playwright MCP  (flow capture — Claude Code)"
fi
if [[ "$IDE" == "cowork" ]] || [[ "$IDE" == "all" ]]; then
echo "    - Browser extension (flow capture — Cowork built-in)"
fi
echo ""
echo "See README.md for MCP setup instructions."
echo ""
echo "Done! Run /setup to configure Gazelle for your company, then try: /research \"your topic\""
