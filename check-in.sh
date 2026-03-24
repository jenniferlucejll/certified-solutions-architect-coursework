#!/bin/zsh

set -euo pipefail

repo_root=${0:A:h}
agents_file="$repo_root/AGENTS.md"

default_section="90/427"
default_topic="RDS Custom for Oracle and Microsoft SQL Server"

if [[ -f "$agents_file" ]]; then
  current_section=$(sed -n 's/^- Completed\/Current Section: `\(.*\)`/\1/p' "$agents_file" | head -n 1)
  current_topic=$(sed -n 's/^- Current Topic: `\(.*\)`/\1/p' "$agents_file" | head -n 1)

  [[ -n "${current_section:-}" ]] && default_section="$current_section"
  [[ -n "${current_topic:-}" ]] && default_topic="$current_topic"
fi

prompt_with_default() {
  local label="$1"
  local default_value="$2"
  local response

  read -r "?$label [$default_value]: " response
  if [[ -z "$response" ]]; then
    print -r -- "$default_value"
  else
    print -r -- "$response"
  fi
}

prompt_required() {
  local label="$1"
  local response=""

  while [[ -z "$response" ]]; do
    read -r "?$label: " response
  done

  print -r -- "$response"
}

print ""
print "AWS Study Check-In"
print "Press Enter to accept the defaults from AGENTS.md."
print ""

section=$(prompt_with_default "Current section" "$default_section")
topic=$(prompt_with_default "Current topic" "$default_topic")
did_today=$(prompt_required "What did you do today")
confidence=$(prompt_required "Confidence (for example 6/10)")
ask=$(prompt_required "What do you want from the agent")
time_available=$(prompt_required "Time available today")

print ""
print "Copy/paste this into your chat:"
print ""
cat <<EOF
Study check-in:

Current section: $section
Current topic: $topic
What I did today: $did_today
Confidence: $confidence
What I want from you: $ask
Time available today: $time_available
EOF
