#!/bin/bash
set -euo pipefail

# CC Starter Setup Script
# Configures Claude Code for a target project with the right profile, skills, and MCPs.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BOLD="\033[1m"
DIM="\033[2m"
GREEN="\033[32m"
YELLOW="\033[33m"
CYAN="\033[36m"
RESET="\033[0m"

print_header() {
    echo ""
    echo -e "${BOLD}${CYAN}$1${RESET}"
    echo "---"
}

print_success() {
    echo -e "  ${GREEN}[done]${RESET} $1"
}

print_info() {
    echo -e "  ${DIM}$1${RESET}"
}

print_warn() {
    echo -e "  ${YELLOW}[skip]${RESET} $1"
}

# --- Validate target path ---

TARGET="${1:-}"
if [ -z "$TARGET" ]; then
    echo ""
    echo -e "${BOLD}CC Starter Setup${RESET}"
    echo ""
    echo "Usage: ./setup.sh <path-to-existing-project>"
    echo ""
    echo "  Point this at an existing project directory — the one with your"
    echo "  package.json, pom.xml, .git/, etc. The script will add AI agent"
    echo "  configuration (CLAUDE.md, skills, MCP servers) to that project."
    echo ""
    echo "Example:"
    echo "  ./setup.sh ~/Documents/code/my-project"
    exit 1
fi

TARGET="$(cd "$TARGET" 2>/dev/null && pwd || echo "$TARGET")"

if [ ! -d "$TARGET" ]; then
    echo "Error: Directory '$TARGET' does not exist."
    exit 1
fi

# Sanity check: warn if this doesn't look like a project directory
if [ ! -d "$TARGET/.git" ] && [ ! -f "$TARGET/package.json" ] && [ ! -f "$TARGET/pom.xml" ] && [ ! -f "$TARGET/build.gradle" ]; then
    echo ""
    echo -e "${YELLOW}Warning:${RESET} '$TARGET' doesn't look like a project directory."
    echo "  (No .git/, package.json, pom.xml, or build.gradle found.)"
    echo ""
    echo "  If you're starting a new project, create one first:"
    echo "    npm create vite@latest my-project -- --template react-ts"
    echo "    cd my-project && npm install"
    echo "    git init && git add -A && git commit -m 'initial scaffold'"
    echo "  Then re-run this script pointing at that directory."
    echo ""
    read -rp "  Continue anyway? (y/n): " CONTINUE_CHOICE
    if [ "$CONTINUE_CHOICE" != "y" ] && [ "$CONTINUE_CHOICE" != "Y" ]; then
        echo "Aborted."
        exit 1
    fi
fi

# Warn if already set up
if [ -f "$TARGET/CLAUDE.md" ] && [ -f "$TARGET/.claude/.cc-config" ]; then
    echo ""
    echo -e "${YELLOW}Warning:${RESET} This project already has a CLAUDE.md and .cc-config."
    echo "  Running setup again will overwrite your CLAUDE.md (including Project Info)."
    echo ""
    echo "  To update to the latest profile and skills without losing your settings:"
    echo "    ./update.sh $TARGET"
    echo ""
    read -rp "  Continue with full setup anyway? (y/n): " OVERWRITE_CHOICE
    if [ "$OVERWRITE_CHOICE" != "y" ] && [ "$OVERWRITE_CHOICE" != "Y" ]; then
        echo "Aborted. Use update.sh instead."
        exit 0
    fi
fi

echo ""
echo -e "${BOLD}CC Starter Setup${RESET}"
echo -e "Target: ${CYAN}$TARGET${RESET}"

# --- Step 1: Choose role ---

print_header "Step 1: Choose your role"
echo ""
echo "  1) Engineer"
echo "  2) Product / Design"
echo ""
read -rp "  Your role (1 or 2): " ROLE_CHOICE

case "$ROLE_CHOICE" in
    1) ROLE="engineer" ;;
    2) ROLE="product-design" ;;
    *)
        echo "Invalid choice. Please enter 1 or 2."
        exit 1
        ;;
esac

echo ""
print_success "Role: $ROLE"

# --- Save config for update.sh ---

mkdir -p "$TARGET/.claude"
echo "role=$ROLE" > "$TARGET/.claude/.cc-config"
print_success "Saved config to .claude/.cc-config"

# --- Step 2: Copy CLAUDE.md ---

print_header "Step 2: Setting up CLAUDE.md"

PROFILE_SRC="$SCRIPT_DIR/profiles/$ROLE/CLAUDE.md"

if [ ! -f "$PROFILE_SRC" ]; then
    echo "Error: Profile not found at $PROFILE_SRC"
    exit 1
fi

cp "$PROFILE_SRC" "$TARGET/CLAUDE.md"
print_success "Copied $ROLE profile to $TARGET/CLAUDE.md"

# --- Step 2b: Git mode (engineers only) ---
# Default is read-only (in CLAUDE.md). Non-default choices go in CLAUDE.local.md
# which is auto-gitignored by Claude Code — personal preference, not shared.

if [ "$ROLE" = "engineer" ]; then
    echo ""
    echo "  How should your AI agent handle git?"
    echo "  (The team default is read-only. Your choice is saved to CLAUDE.local.md — personal, not committed.)"
    echo ""
    echo "    a) Read-only   -- You handle all git. Agent never touches it. (default)"
    echo "    b) Approval    -- Agent explains git actions, waits for your OK."
    echo "    c) Autonomous  -- Agent handles branching, commits, PRs freely."
    echo ""
    read -rp "  Git mode (a, b, or c): " GIT_CHOICE

    case "$GIT_CHOICE" in
        a|A)
            print_success "Git mode: read-only (team default, no override needed)"
            ;;
        b|B)
            echo "GIT_MODE: approval -- Agent explains git actions, waits for your OK." > "$TARGET/CLAUDE.local.md"
            print_success "Git mode: approval (saved to CLAUDE.local.md)"
            ;;
        c|C)
            echo "GIT_MODE: autonomous -- Agent handles branching, commits, PRs freely." > "$TARGET/CLAUDE.local.md"
            print_success "Git mode: autonomous (saved to CLAUDE.local.md)"
            ;;
        *)
            print_success "Git mode: read-only (team default)"
            ;;
    esac
fi

# --- Step 3: Copy skills ---

print_header "Step 3: Setting up skills"

mkdir -p "$TARGET/.claude/skills"

# Always copy shared skills
for SKILL in spec-driven-dev.md iterative-commits.md pr-workflow.md skill-creation.md; do
    if [ -f "$SCRIPT_DIR/skills/$SKILL" ]; then
        cp "$SCRIPT_DIR/skills/$SKILL" "$TARGET/.claude/skills/"
        print_success "Copied $SKILL"
    fi
done

# Ask about frontend skills
read -rp "  Does this project use React/Zustand? (y/n): " REACT_CHOICE
if [ "$REACT_CHOICE" = "y" ] || [ "$REACT_CHOICE" = "Y" ]; then
    for SKILL in component-creation.md dom-utility-testing.md store-first-feature.md zustand-store-testing.md; do
        if [ -f "$SCRIPT_DIR/skills/$SKILL" ]; then
            cp "$SCRIPT_DIR/skills/$SKILL" "$TARGET/.claude/skills/"
            print_success "Copied $SKILL"
        fi
    done
fi

# --- Step 4: MCP server setup ---
# All MCP servers are added at user scope so API keys stay out of the project.

print_header "Step 4: MCP server setup"
echo ""
echo "  MCP servers extend your agent with live docs, memory, and GitHub access."
echo "  Keys are stored in your user config (not in the project)."
echo "  (You can skip any step and do it later.)"

# Context7
echo ""
echo -e "  ${BOLD}Context7${RESET} - Up-to-date documentation for libraries and frameworks"
echo "  Get a free API key at: https://context7.com/dashboard"
read -rp "  Open in browser? (y/n): " C7_OPEN
if [ "$C7_OPEN" = "y" ] || [ "$C7_OPEN" = "Y" ]; then
    open "https://context7.com/dashboard" 2>/dev/null || xdg-open "https://context7.com/dashboard" 2>/dev/null || true
fi
read -rp "  Paste your Context7 API key (or press Enter to skip): " C7_KEY
if [ -n "$C7_KEY" ]; then
    claude mcp add context7 --scope user -- npx -y @upstash/context7-mcp --api-key "$C7_KEY" 2>/dev/null && \
        print_success "Context7 configured" || \
        print_warn "Context7 setup failed. Run manually: claude mcp add context7 --scope user -- npx -y @upstash/context7-mcp --api-key YOUR_KEY"
else
    print_warn "Skipped Context7. Works without a key (rate-limited). Get one later at context7.com/dashboard"
fi

# OpenMemory
echo ""
echo -e "  ${BOLD}OpenMemory (Mem0)${RESET} - Persistent memory across conversations"
echo "  Get an API key at: https://mem0.ai"
read -rp "  Open in browser? (y/n): " MEM_OPEN
if [ "$MEM_OPEN" = "y" ] || [ "$MEM_OPEN" = "Y" ]; then
    open "https://mem0.ai" 2>/dev/null || xdg-open "https://mem0.ai" 2>/dev/null || true
fi
read -rp "  Paste your Mem0 API key (or press Enter to skip): " MEM_KEY
if [ -n "$MEM_KEY" ]; then
    claude mcp add openmemory --scope user -- npx -y @mem0/openmemory-mcp --api-key "$MEM_KEY" 2>/dev/null && \
        print_success "OpenMemory configured" || \
        print_warn "OpenMemory setup failed. Run manually: claude mcp add openmemory --scope user -- npx -y @mem0/openmemory-mcp --api-key YOUR_KEY"
else
    print_warn "Skipped OpenMemory. Get a key later at mem0.ai"
fi

# GitHub
echo ""
echo -e "  ${BOLD}GitHub MCP${RESET} - Interact with repos, PRs, and issues"
echo "  Create a Personal Access Token at: https://github.com/settings/tokens"
echo "  Required scopes: repo, read:org"
read -rp "  Open in browser? (y/n): " GH_OPEN
if [ "$GH_OPEN" = "y" ] || [ "$GH_OPEN" = "Y" ]; then
    open "https://github.com/settings/tokens" 2>/dev/null || xdg-open "https://github.com/settings/tokens" 2>/dev/null || true
fi
read -rp "  Paste your GitHub PAT (or press Enter to skip): " GH_KEY
if [ -n "$GH_KEY" ]; then
    claude mcp add github --scope user -- npx -y @anthropic/github-mcp --token "$GH_KEY" 2>/dev/null && \
        print_success "GitHub MCP configured" || \
        print_warn "GitHub MCP setup failed. Run manually: claude mcp add github --scope user -- npx -y @anthropic/github-mcp --token YOUR_TOKEN"
else
    print_warn "Skipped GitHub MCP. Create a PAT later at github.com/settings/tokens"
fi

# --- Step 5: Beads (engineers only) ---

if [ "$ROLE" = "engineer" ]; then
    print_header "Step 5: Task tracking (Beads)"

    if command -v bd &>/dev/null; then
        print_success "Beads is installed ($(bd --version 2>/dev/null || echo 'version unknown'))"
    else
        echo "  Beads is not installed. It's recommended for engineers."
        echo "  Install: npm install -g @steveyegge/beads"
        echo "  Or: brew install beads"
        echo "  More info: https://github.com/steveyegge/beads"
        echo ""
        read -rp "  Install now with npm? (y/n): " BD_INSTALL
        if [ "$BD_INSTALL" = "y" ] || [ "$BD_INSTALL" = "Y" ]; then
            npm install -g @steveyegge/beads && print_success "Beads installed" || print_warn "Install failed. Try manually."
        else
            print_warn "Skipped Beads install. Claude Code's built-in TodoWrite works as a fallback."
        fi
    fi
fi

# --- Done ---

print_header "Setup complete!"
echo ""
echo "  Files created in $TARGET:"
echo "    CLAUDE.md              - AI agent configuration"
echo "    .claude/skills/        - Reusable skill documents"
echo ""
echo "  Next steps:"
echo "    1. Edit CLAUDE.md to fill in Project Info at the top"
echo "    2. Open the project in Claude Code and start working"
echo ""

if [ "$ROLE" = "engineer" ]; then
    echo "  For agent role ideas, browse:"
    echo "    https://github.com/VoltAgent/awesome-claude-code-subagents"
    echo "    Copy individual .md files you want -- don't install the full collection."
    echo ""
fi

if [ "$ROLE" = "product-design" ]; then
    echo "  For voice-driven development, try Wispr:"
    echo "    https://www.wispr.com/"
    echo "    Talk instead of type - great for describing what you want to build."
    echo ""
fi

echo "  Onboarding docs: $SCRIPT_DIR/docs/onboarding/"
echo ""
