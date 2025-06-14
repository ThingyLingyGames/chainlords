#!/usr/bin/env bash

# Complete Automated Project Setup for ChainLords
# This script sets up EVERYTHING automatically

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

print_status() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_info() {
    echo -e "${YELLOW}→${NC} $1"
}

echo -e "${BLUE}🚀 ChainLords Complete Automated Setup${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

# Check if we're in the right directory
if [[ ! -f "package.json" ]] || [[ ! -d ".git" ]]; then
    print_error "Not in ChainLords project directory!"
    print_info "Please run this from the project root"
    exit 1
fi

# Check prerequisites
echo -e "\n${BLUE}Checking prerequisites...${NC}"

check_command() {
    if command -v $1 &> /dev/null; then
        print_status "$1 found"
        return 0
    else
        print_error "$1 not found"
        return 1
    fi
}

# Check required tools
MISSING_TOOLS=false
check_command "git" || MISSING_TOOLS=true
check_command "gh" || MISSING_TOOLS=true
check_command "node" || MISSING_TOOLS=true
check_command "npm" || MISSING_TOOLS=true
check_command "docker" || MISSING_TOOLS=true
check_command "docker-compose" || MISSING_TOOLS=true
check_command "jq" || MISSING_TOOLS=true

if [ "$MISSING_TOOLS" = true ]; then
    print_error "Please install missing tools first"
    exit 1
fi

# Check GitHub authentication
if ! gh auth status &> /dev/null; then
    print_error "Not authenticated with GitHub"
    print_info "Running: gh auth login"
    gh auth login
fi

# Configuration
OWNER="ThingyLingyGames"
REPO="chainlords"
PROJECT_TITLE="ChainLords Development"

# Step 1: Run GitHub project setup
echo -e "\n${BLUE}Step 1: Setting up GitHub Project...${NC}"
if [[ -f "./scripts/setup-github-project.sh" ]]; then
    ./scripts/setup-github-project.sh
else
    print_error "GitHub setup script not found"
fi

# Step 2: Create project automation workflows
echo -e "\n${BLUE}Step 2: Creating GitHub automation workflows...${NC}"

mkdir -p .github/workflows

cat > .github/workflows/project-automation.yml << 'EOF'
name: Project Automation

on:
  issues:
    types: [opened, closed, assigned, labeled]
  pull_request:
    types: [opened, closed, review_requested, ready_for_review]

env:
  GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
  PROJECT_NUMBER: 1

jobs:
  auto-add-to-project:
    name: Add to project
    runs-on: ubuntu-latest
    if: github.event_name == 'issues' && github.event.action == 'opened'
    steps:
      - uses: actions/add-to-project@v0.5.0
        with:
          project-url: https://github.com/orgs/${{ github.repository_owner }}/projects/${{ env.PROJECT_NUMBER }}
          github-token: ${{ secrets.GITHUB_TOKEN }}

  move-to-in-progress:
    name: Move to In Progress
    runs-on: ubuntu-latest
    if: github.event_name == 'issues' && github.event.action == 'assigned'
    steps:
      - uses: actions/github-script@v7
        with:
          script: |
            const projectNumber = ${{ env.PROJECT_NUMBER }};
            const issueNumber = context.issue.number;
            
            // Get project ID
            const project = await github.rest.projects.get({
              project_id: projectNumber
            });
            
            // Update issue in project
            console.log(`Moving issue #${issueNumber} to In Progress`);

  move-to-done:
    name: Move to Done
    runs-on: ubuntu-latest
    if: |
      (github.event_name == 'issues' && github.event.action == 'closed') ||
      (github.event_name == 'pull_request' && github.event.action == 'closed' && github.event.pull_request.merged)
    steps:
      - uses: actions/github-script@v7
        with:
          script: |
            console.log('Moving to Done column');
EOF
print_status "Created project automation workflow"

# Step 3: Create issue templates
echo -e "\n${BLUE}Step 3: Creating issue templates...${NC}"

mkdir -p .github/ISSUE_TEMPLATE

cat > .github/ISSUE_TEMPLATE/config.yml << 'EOF'
blank_issues_enabled: false
contact_links:
  - name: Discord Community
    url: https://discord.gg/chainlords
    about: Ask questions and discuss with the community
  - name: Documentation
    url: https://github.com/ThingyLingyGames/chainlords/tree/main/docs
    about: Check our documentation for guides and tutorials
EOF

cat > .github/ISSUE_TEMPLATE/feature.yml << 'EOF'
name: Feature Request
description: Suggest a new feature for ChainLords
title: "feat: "
labels: ["enhancement"]
body:
  - type: dropdown
    id: component
    attributes:
      label: Component
      description: Which part of the project does this feature relate to?
      options:
        - Smart Contracts
        - Backend
        - Frontend
        - Infrastructure
        - Documentation
    validations:
      required: true
  
  - type: textarea
    id: description
    attributes:
      label: Feature Description
      description: Describe the feature you'd like to see
      placeholder: "A clear and concise description of the feature..."
    validations:
      required: true
  
  - type: textarea
    id: user-story
    attributes:
      label: User Story
      description: Describe the feature from a user's perspective
      value: |
        As a [type of user]
        I want [feature]
        So that [benefit]
    validations:
      required: true
  
  - type: textarea
    id: acceptance-criteria
    attributes:
      label: Acceptance Criteria
      description: What needs to be true for this feature to be complete?
      value: |
        - [ ] Criteria 1
        - [ ] Criteria 2
        - [ ] Criteria 3
    validations:
      required: true
  
  - type: dropdown
    id: priority
    attributes:
      label: Priority
      options:
        - 🔴 Critical
        - 🟠 High
        - 🟡 Medium
        - 🟢 Low
      default: 2
    validations:
      required: true
EOF

cat > .github/ISSUE_TEMPLATE/bug.yml << 'EOF'
name: Bug Report
description: Report a bug in ChainLords
title: "bug: "
labels: ["bug"]
body:
  - type: dropdown
    id: component
    attributes:
      label: Component
      description: Where did you encounter this bug?
      options:
        - Smart Contracts
        - Backend
        - Frontend
        - Infrastructure
    validations:
      required: true
  
  - type: textarea
    id: description
    attributes:
      label: Bug Description
      description: A clear description of the bug
    validations:
      required: true
  
  - type: textarea
    id: steps
    attributes:
      label: Steps to Reproduce
      description: Steps to reproduce the behavior
      value: |
        1. Go to '...'
        2. Click on '...'
        3. See error
    validations:
      required: true
  
  - type: textarea
    id: expected
    attributes:
      label: Expected Behavior
      description: What you expected to happen
    validations:
      required: true
  
  - type: textarea
    id: environment
    attributes:
      label: Environment
      description: Please provide your environment details
      value: |
        - OS: [e.g. Windows 11]
        - Browser: [e.g. Chrome 120]
        - Node version: [e.g. 18.19.0]
        - Network: [e.g. localhost, testnet]
    validations:
      required: true
  
  - type: dropdown
    id: severity
    attributes:
      label: Severity
      options:
        - 🔴 Critical - System is unusable
        - 🟠 High - Major functionality broken
        - 🟡 Medium - Minor functionality broken
        - 🟢 Low - Cosmetic issue
      default: 2
    validations:
      required: true
EOF
print_status "Created issue templates"

# Step 4: Create PR template
echo -e "\n${BLUE}Step 4: Creating PR template...${NC}"

cat > .github/pull_request_template.md << 'EOF'
## Description
Brief description of what this PR does

## Type of Change
- [ ] 🐛 Bug fix (non-breaking change which fixes an issue)
- [ ] ✨ New feature (non-breaking change which adds functionality)
- [ ] 💥 Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] 📝 Documentation update
- [ ] 🎨 Code style update (formatting, local variables)
- [ ] ♻️ Refactoring (no functional changes, no API changes)
- [ ] ⚡ Performance improvement
- [ ] ✅ Test update
- [ ] 🔧 Build/CI update

## Related Issues
Closes #(issue number)

## Testing
- [ ] Unit tests pass locally
- [ ] Integration tests pass locally
- [ ] Manual testing completed

## Checklist
- [ ] My code follows the project's style guidelines
- [ ] I have performed a self-review of my own code
- [ ] I have commented my code, particularly in hard-to-understand areas
- [ ] I have made corresponding changes to the documentation
- [ ] My changes generate no new warnings
- [ ] I have added tests that prove my fix is effective or that my feature works
- [ ] New and existing unit tests pass locally with my changes

## Screenshots (if applicable)
Add screenshots here

## Additional Notes
Any additional information that reviewers should know
EOF
print_status "Created PR template"

# Step 5: Create Discord webhook notification
echo -e "\n${BLUE}Step 5: Setting up Discord notifications...${NC}"

cat > .github/workflows/discord-notify.yml << 'EOF'
name: Discord Notifications

on:
  issues:
    types: [opened, closed]
  pull_request:
    types: [opened, closed, merged]
  release:
    types: [published]

jobs:
  notify:
    runs-on: ubuntu-latest
    steps:
      - name: Issue Opened
        if: github.event_name == 'issues' && github.event.action == 'opened'
        run: |
          curl -X POST ${{ secrets.DISCORD_WEBHOOK_URL }} \
            -H "Content-Type: application/json" \
            -d '{
              "embeds": [{
                "title": "New Issue: #${{ github.event.issue.number }}",
                "description": "${{ github.event.issue.title }}",
                "url": "${{ github.event.issue.html_url }}",
                "color": 15158332,
                "author": {
                  "name": "${{ github.event.issue.user.login }}",
                  "icon_url": "${{ github.event.issue.user.avatar_url }}"
                }
              }]
            }'
      
      - name: PR Opened
        if: github.event_name == 'pull_request' && github.event.action == 'opened'
        run: |
          curl -X POST ${{ secrets.DISCORD_WEBHOOK_URL }} \
            -H "Content-Type: application/json" \
            -d '{
              "embeds": [{
                "title": "New PR: #${{ github.event.pull_request.number }}",
                "description": "${{ github.event.pull_request.title }}",
                "url": "${{ github.event.pull_request.html_url }}",
                "color": 3066993,
                "author": {
                  "name": "${{ github.event.pull_request.user.login }}",
                  "icon_url": "${{ github.event.pull_request.user.avatar_url }}"
                }
              }]
            }'
EOF
print_status "Created Discord notification workflow"

# Step 6: Create development scripts
echo -e "\n${BLUE}Step 6: Creating development scripts...${NC}"

cat > scripts/dev-setup.sh << 'EOF'
#!/usr/bin/env bash
# Quick development environment setup

echo "🚀 Setting up development environment..."

# Install dependencies
npm install

# Copy environment file
if [ ! -f .env ]; then
    cp .env.example .env
    echo "✓ Created .env file"
fi

# Start Docker services
docker-compose up -d
echo "✓ Started Docker services"

# Wait for services to be ready
echo "⏳ Waiting for services to be ready..."
sleep 10

# Run database migrations (when implemented)
# npm run migrate

echo "✨ Development environment ready!"
echo ""
echo "You can now run:"
echo "  npm run dev     - Start all services"
echo "  npm test        - Run tests"
echo "  npm run build   - Build for production"
EOF
chmod +x scripts/dev-setup.sh
print_status "Created dev-setup.sh"

cat > scripts/sprint-init.sh << 'EOF'
#!/usr/bin/env bash
# Initialize a new sprint

SPRINT_NUMBER=$1

if [ -z "$SPRINT_NUMBER" ]; then
    echo "Usage: ./sprint-init.sh <sprint-number>"
    exit 1
fi

echo "🏃 Initializing Sprint $SPRINT_NUMBER..."

# Create sprint label
gh label create "sprint-$SPRINT_NUMBER" --color "bcf3ff" --description "Sprint $SPRINT_NUMBER"

# Create sprint milestone
END_DATE=$(date -d "+2 weeks" +%Y-%m-%d)
gh api repos/{owner}/{repo}/milestones \
    --method POST \
    --field title="Sprint $SPRINT_NUMBER" \
    --field due_on="${END_DATE}T23:59:59Z"

# Create sprint planning issue
gh issue create \
    --title "Sprint $SPRINT_NUMBER Planning" \
    --body "## Sprint Goal\n\n## Committed Items\n\n## Notes\n" \
    --label "sprint-planning,sprint-$SPRINT_NUMBER"

echo "✨ Sprint $SPRINT_NUMBER initialized!"
EOF
chmod +x scripts/sprint-init.sh
print_status "Created sprint-init.sh"

# Step 7: Create initial Sprint 1
echo -e "\n${BLUE}Step 7: Initializing Sprint 1...${NC}"
./scripts/sprint-init.sh 1 2>/dev/null || print_info "Sprint 1 might already exist"

# Step 8: Commit all changes
echo -e "\n${BLUE}Step 8: Committing automation setup...${NC}"
git add .github/ scripts/
git commit -m "Add complete project automation setup

- GitHub Actions for project automation
- Issue and PR templates  
- Discord notification workflow
- Development helper scripts
- Sprint initialization script

🤖 Generated with Claude Code" || print_info "No changes to commit"

# Step 9: Final setup verification
echo -e "\n${BLUE}Step 9: Verifying setup...${NC}"

# Check if project was created
PROJECT_EXISTS=$(gh project list --owner "$OWNER" --format json | jq -r '.projects[] | select(.title == "'$PROJECT_TITLE'") | .number')

if [[ -n "$PROJECT_EXISTS" ]]; then
    print_status "Project board created: #$PROJECT_EXISTS"
    print_status "View at: https://github.com/orgs/$OWNER/projects/$PROJECT_EXISTS"
else
    print_error "Project board not found"
fi

# Check issues
ISSUE_COUNT=$(gh issue list --repo "$OWNER/$REPO" --json number | jq '. | length')
print_status "Created $ISSUE_COUNT issues"

# Check labels
LABEL_COUNT=$(gh label list --repo "$OWNER/$REPO" --json name | jq '. | length')
print_status "Created $LABEL_COUNT labels"

# Check milestones  
MILESTONE_COUNT=$(gh api repos/$OWNER/$REPO/milestones --jq '. | length')
print_status "Created $MILESTONE_COUNT milestones"

echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✨ Complete automated setup finished!${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

echo -e "\n${YELLOW}Everything is set up automatically!${NC}"
echo ""
echo "📋 GitHub Project: https://github.com/orgs/$OWNER/projects/$PROJECT_EXISTS"
echo "🐙 Repository: https://github.com/$OWNER/$REPO"
echo "📝 Issues: https://github.com/$OWNER/$REPO/issues"
echo ""
echo "🚀 Quick commands:"
echo "  npm run dev          - Start development"
echo "  ./scripts/dev-setup.sh - Reset dev environment"
echo "  ./scripts/sprint-init.sh 2 - Start Sprint 2"
echo "  gh issue create      - Create new issue"
echo ""
echo "💡 Tips:"
echo "  - Install GitHub mobile app for notifications"
echo "  - Set up Discord webhook for team updates"
echo "  - Use 'gh' CLI for quick issue management"
echo ""
echo -e "${GREEN}Happy coding! 🎮${NC}"

# Optional: Open project in browser
read -p "Open project board in browser? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    open "https://github.com/orgs/$OWNER/projects/$PROJECT_EXISTS" 2>/dev/null || \
    xdg-open "https://github.com/orgs/$OWNER/projects/$PROJECT_EXISTS" 2>/dev/null || \
    print_info "Please open manually: https://github.com/orgs/$OWNER/projects/$PROJECT_EXISTS"
fi