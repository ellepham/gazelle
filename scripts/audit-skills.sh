#!/usr/bin/env bash
# Audit Gazelle skill frontmatter completeness
# Usage: ./scripts/audit-skills.sh

set -euo pipefail

SKILLS_DIR="$(dirname "$0")/../gazelle/skills"
AGENTS_DIR="$(dirname "$0")/../gazelle/agents"

echo "╔══════════════════════════════════════╗"
echo "║     Gazelle Skill Audit              ║"
echo "╚══════════════════════════════════════╝"
echo ""

total=0
with_when_to_use=0
with_model=0
with_argument_hint=0
with_allowed_tools=0
with_effort=0
with_fork=0
issues=0

for skill_dir in "$SKILLS_DIR"/*/; do
  skill_name="$(basename "$skill_dir")"
  skill_file="$skill_dir/SKILL.md"

  if [[ ! -f "$skill_file" ]]; then
    continue
  fi

  total=$((total + 1))

  # Extract frontmatter
  fm=$(sed -n '/^---$/,/^---$/p' "$skill_file" | head -20)

  has_issue=false
  issue_details=""

  # Check when_to_use
  if echo "$fm" | grep -q "when_to_use"; then
    with_when_to_use=$((with_when_to_use + 1))
  elif [[ "$skill_name" != setup-* ]]; then
    has_issue=true
    issue_details+="  ⚠️  Missing when_to_use (critical for auto-invocation)\n"
  fi

  # Check model
  if echo "$fm" | grep -q "model:"; then
    with_model=$((with_model + 1))
  fi

  # Check argument-hint
  if echo "$fm" | grep -q "argument-hint"; then
    with_argument_hint=$((with_argument_hint + 1))
  fi

  # Check allowed-tools
  if echo "$fm" | grep -q "allowed-tools"; then
    with_allowed_tools=$((with_allowed_tools + 1))
  fi

  # Check effort
  if echo "$fm" | grep -q "effort:"; then
    with_effort=$((with_effort + 1))
  fi

  # Check fork
  if echo "$fm" | grep -q "context.*fork"; then
    with_fork=$((with_fork + 1))
  fi

  if $has_issue; then
    issues=$((issues + 1))
    echo "❌ $skill_name"
    echo -e "$issue_details"
  fi
done

echo ""
echo "=== Summary ==="
echo "  Total skills:     $total"
echo "  with when_to_use: $with_when_to_use / $total"
echo "  with model:       $with_model / $total"
echo "  with arg-hint:    $with_argument_hint / $total"
echo "  with allowed-tools: $with_allowed_tools / $total"
echo "  with effort:      $with_effort / $total"
echo "  with fork:        $with_fork / $total"
echo ""

if [[ $issues -eq 0 ]]; then
  echo "✅ All skills pass audit!"
else
  echo "⚠️  $issues skill(s) have issues"
fi

# Agents audit
echo ""
echo "=== Agents ==="
for agent_file in "$AGENTS_DIR"/*.md; do
  agent_name="$(basename "$agent_file" .md)"
  fm=$(sed -n '/^---$/,/^---$/p' "$agent_file" | head -10)

  model="$(echo "$fm" | grep "model:" | sed 's/.*model: *//' | tr -d ' ')"
  tools="$(echo "$fm" | grep "tools:" | sed 's/.*tools: *//')"

  echo "  $agent_name: model=$model tools=${tools:-inherit}"
done

echo ""
echo "Done!"
