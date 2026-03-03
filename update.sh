#!/bin/bash
set -euo pipefail

# CC Starter Update Script
# Pulls latest CLAUDE.md profile and skills into a project without
# overwriting project-specific settings (Project Info).

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BOLD="\033[1m"
GREEN="\033[32m"
YELLOW="\033[33m"
CYAN="\033[36m"
RESET="\033[0m"

print_success() {
    echo -e "  ${GREEN}[updated]${RESET} $1"
}

print_skip() {
    echo -e "  ${YELLOW}[skip]${RESET} $1"
}

print_info() {
    echo -e "  ${CYAN}[info]${RESET} $1"
}

# --- Validate target path ---

TARGET="${1:-}"
if [ -z "$TARGET" ]; then
    echo ""
    echo -e "${BOLD}CC Starter Update${RESET}"
    echo ""
    echo "Usage: ./update.sh <path-to-your-project>"
    echo ""
    echo "  Updates CLAUDE.md and skills to the latest versions from cc-starter"
    echo "  while preserving your project-specific settings (Project Info, git mode)."
    echo ""
    echo "  Run setup.sh first if you haven't already."
    exit 1
fi

TARGET="$(cd "$TARGET" 2>/dev/null && pwd || echo "$TARGET")"

if [ ! -d "$TARGET" ]; then
    echo "Error: Directory '$TARGET' does not exist."
    exit 1
fi

# --- Read config from setup ---

CONFIG="$TARGET/.claude/.cc-config"
if [ ! -f "$CONFIG" ]; then
    echo "Error: No .claude/.cc-config found in '$TARGET'."
    echo "  Run setup.sh first to configure this project."
    exit 1
fi

source "$CONFIG"

if [ -z "${role:-}" ]; then
    echo "Error: .cc-config is missing the role field."
    exit 1
fi

PROFILE_SRC="$SCRIPT_DIR/profiles/$role/CLAUDE.md"
if [ ! -f "$PROFILE_SRC" ]; then
    echo "Error: Profile not found at $PROFILE_SRC"
    exit 1
fi

echo ""
echo -e "${BOLD}CC Starter Update${RESET}"
echo -e "Target: ${CYAN}$TARGET${RESET}"
echo -e "Role:   ${CYAN}$role${RESET}"
echo -e "Source: ${CYAN}$SCRIPT_DIR${RESET} (cc-starter)"

# --- Step 1: Update CLAUDE.md (preserve preferences) ---

echo ""
echo -e "${BOLD}${CYAN}Updating CLAUDE.md${RESET}"
echo "---"

EXISTING="$TARGET/CLAUDE.md"

if [ -f "$EXISTING" ]; then
    # Strategy: splice the user's preferences block into the fresh profile.
    # Both profiles have the structure: [header] --- [prefs] --- [rules...]
    # We keep the fresh header and rules, but preserve the user's prefs.

    PREFS_FILE=$(mktemp)
    HEADER_FILE=$(mktemp)
    REST_FILE=$(mktemp)

    # From existing: extract preferences (between first --- and second ---, second --- included)
    awk '/^---$/{c++; if(c==2){print; exit}; next} c==1{print}' "$EXISTING" > "$PREFS_FILE"

    # From fresh profile: extract header (up to and including first ---)
    awk '/^---$/{print; exit} {print}' "$PROFILE_SRC" > "$HEADER_FILE"

    # From fresh profile: extract everything after second ---
    awk '/^---$/{c++; if(c==2){found=1; next}} found{print}' "$PROFILE_SRC" > "$REST_FILE"

    if [ -s "$PREFS_FILE" ]; then
        cat "$HEADER_FILE" "$PREFS_FILE" "$REST_FILE" > "$EXISTING"
        print_success "CLAUDE.md (preferences preserved)"
    else
        cp "$PROFILE_SRC" "$EXISTING"
        print_success "CLAUDE.md (fresh copy — no preferences found to preserve)"
    fi

    rm -f "$PREFS_FILE" "$HEADER_FILE" "$REST_FILE"
else
    cp "$PROFILE_SRC" "$EXISTING"
    print_success "CLAUDE.md (new — no existing file found)"
fi

# --- Step 2: Update skills ---

echo ""
echo -e "${BOLD}${CYAN}Updating skills${RESET}"
echo "---"

mkdir -p "$TARGET/.claude/skills"

# Always update shared workflow skills
for SKILL in spec-driven-dev.md iterative-commits.md pr-workflow.md skill-creation.md; do
    if [ -f "$SCRIPT_DIR/skills/$SKILL" ]; then
        cp "$SCRIPT_DIR/skills/$SKILL" "$TARGET/.claude/skills/"
        print_success "$SKILL"
    fi
done

# Update React/Zustand skills if previously opted in
REACT_SKILLS=(component-creation.md dom-utility-testing.md store-first-feature.md zustand-store-testing.md)
REACT_EXISTS=false
for SKILL in "${REACT_SKILLS[@]}"; do
    if [ -f "$TARGET/.claude/skills/$SKILL" ]; then
        REACT_EXISTS=true
        break
    fi
done

if [ "$REACT_EXISTS" = true ]; then
    for SKILL in "${REACT_SKILLS[@]}"; do
        if [ -f "$SCRIPT_DIR/skills/$SKILL" ]; then
            cp "$SCRIPT_DIR/skills/$SKILL" "$TARGET/.claude/skills/"
            print_success "$SKILL"
        fi
    done
else
    print_skip "React/Zustand skills (not in use)"
fi

# --- Done ---

echo ""
echo -e "${BOLD}${CYAN}Update complete!${RESET}"
echo ""
echo "  What was updated:"
echo "    CLAUDE.md              - Latest profile for $role"
echo "    .claude/skills/        - Latest shared skills"
echo ""
echo "  What was NOT touched:"
echo "    MCP servers             - User-scoped, not in the project"
echo "    CLAUDE.local.md         - Your personal settings"
echo "    Project Info in CLAUDE.md preserved"
echo ""
echo "  Verify: open the project in Claude Code and confirm the agent"
echo "  reads your updated CLAUDE.md at the start of a conversation."
echo ""
