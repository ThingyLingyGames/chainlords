# GitHub Project Board Setup Script

This script will help you quickly set up your GitHub Project board with all the necessary configurations.

## Prerequisites
- GitHub CLI (`gh`) installed and authenticated
- Repository already created

## Automated Setup Script

Create a file called `setup-github-project.sh`:

```bash
#!/usr/bin/env bash

# Configuration
OWNER="ThingyLingyGames"
REPO="chainlords"
PROJECT_TITLE="ChainLords Development"

echo "🚀 Setting up GitHub Project for $OWNER/$REPO"

# Create the project
echo "Creating project board..."
PROJECT_ID=$(gh project create --owner $OWNER --title "$PROJECT_TITLE" --format json | jq -r '.id')

echo "Project created with ID: $PROJECT_ID"

# Create custom fields
echo "Adding custom fields..."

# Story Points field
gh project field-create $PROJECT_ID \
  --owner $OWNER \
  --name "Story Points" \
  --data-type NUMBER

# Priority field  
gh project field-create $PROJECT_ID \
  --owner $OWNER \
  --name "Priority" \
  --data-type SINGLE_SELECT \
  --single-select-options "🔴 Critical,🟠 High,🟡 Medium,🟢 Low"

# Component field
gh project field-create $PROJECT_ID \
  --owner $OWNER \
  --name "Component" \
  --data-type SINGLE_SELECT \
  --single-select-options "Smart Contracts,Backend,Frontend,Infrastructure,Documentation"

# Sprint field
gh project field-create $PROJECT_ID \
  --owner $OWNER \
  --name "Sprint" \
  --data-type TEXT

echo "✅ Custom fields created"

# Create initial issues for project structure
echo "Creating initial issues..."

# Create epic issues
gh issue create \
  --repo $OWNER/$REPO \
  --title "Epic: Smart Contract Development" \
  --body "Develop and deploy all smart contracts for ChainLords" \
  --label "epic,smart-contracts"

gh issue create \
  --repo $OWNER/$REPO \
  --title "Epic: Frontend Development" \
  --body "Build the complete frontend application" \
  --label "epic,frontend"

gh issue create \
  --repo $OWNER/$REPO \
  --title "Epic: Backend API Development" \
  --body "Develop the backend API and services" \
  --label "epic,backend"

# Create Sprint 1 tasks
gh issue create \
  --repo $OWNER/$REPO \
  --title "feat: Implement EMPIRE token contract" \
  --body "Create the main ERC20 token contract with minting and burning capabilities" \
  --label "enhancement,smart-contracts,sprint-1" \
  --project $PROJECT_ID

gh issue create \
  --repo $OWNER/$REPO \
  --title "feat: Create landing page" \
  --body "Design and implement the main landing page" \
  --label "enhancement,frontend,sprint-1" \
  --project $PROJECT_ID

gh issue create \
  --repo $OWNER/$REPO \
  --title "feat: Set up authentication system" \
  --body "Implement JWT + Web3 wallet authentication" \
  --label "enhancement,backend,sprint-1" \
  --project $PROJECT_ID

echo "✅ Initial issues created"

# Create milestones
echo "Creating milestones..."

gh api repos/$OWNER/$REPO/milestones \
  --method POST \
  --field title="Alpha Release" \
  --field description="First playable version on testnet" \
  --field due_on="2025-04-30T23:59:59Z"

gh api repos/$OWNER/$REPO/milestones \
  --method POST \
  --field title="Beta Release" \
  --field description="Feature-complete version for testing" \
  --field due_on="2025-06-30T23:59:59Z"

gh api repos/$OWNER/$REPO/milestones \
  --method POST \
  --field title="Mainnet Launch" \
  --field description="Official launch on mainnet" \
  --field due_on="2025-09-30T23:59:59Z"

echo "✅ Milestones created"

echo "🎉 GitHub Project setup complete!"
echo "View your project at: https://github.com/orgs/$OWNER/projects"
```

## Manual Setup Guide

If you prefer to set up manually or need to customize:

### 1. Create Project Board
```bash
gh project create --owner ThingyLingyGames --title "ChainLords Development"
```

### 2. Add Issues to Project
```bash
# List recent issues
gh issue list --repo ThingyLingyGames/chainlords

# Add issue to project
gh issue edit ISSUE_NUMBER --add-project "ChainLords Development"
```

### 3. Create Issue Templates

Create `.github/ISSUE_TEMPLATE/task.yml`:
```yaml
name: Task
description: Create a new development task
title: "[Component]: "
labels: ["task"]
body:
  - type: dropdown
    id: component
    attributes:
      label: Component
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
      label: Description
      description: Detailed description of the task
    validations:
      required: true
  
  - type: textarea
    id: acceptance
    attributes:
      label: Acceptance Criteria
      description: What needs to be done for this task to be complete?
      value: |
        - [ ] Criteria 1
        - [ ] Criteria 2
        - [ ] Criteria 3
    validations:
      required: true
  
  - type: dropdown
    id: story-points
    attributes:
      label: Story Points
      options:
        - "1"
        - "2"
        - "3"
        - "5"
        - "8"
        - "13"
    validations:
      required: true
```

### 4. Workflow Automation

Create `.github/workflows/project-automation.yml`:
```yaml
name: Project Automation

on:
  issues:
    types: [opened, closed, assigned]
  pull_request:
    types: [opened, closed, review_requested]

jobs:
  add-to-project:
    name: Add to project
    runs-on: ubuntu-latest
    steps:
      - uses: actions/add-to-project@v0.5.0
        with:
          project-url: https://github.com/orgs/ThingyLingyGames/projects/1
          github-token: ${{ secrets.GITHUB_TOKEN }}
          
  move-on-close:
    name: Move to Done when closed
    runs-on: ubuntu-latest
    if: github.event.issue.state == 'closed' || github.event.pull_request.state == 'closed'
    steps:
      - uses: alex-page/github-project-automation-plus@v0.8.3
        with:
          project: ChainLords Development
          column: Done
          repo-token: ${{ secrets.GITHUB_TOKEN }}
```

## Sprint Management

### Sprint Planning Checklist
- [ ] Review backlog items
- [ ] Estimate story points
- [ ] Check team capacity
- [ ] Prioritize tasks
- [ ] Assign to team members
- [ ] Update sprint field

### Daily Standup Template
```markdown
## Daily Standup - [DATE]

### Yesterday
- Completed: #123, #124
- Progress on: #125

### Today
- Working on: #125, #126
- Reviewing: #122

### Blockers
- Waiting for design approval on #127
```

### Sprint Review Template
```markdown
## Sprint [NUMBER] Review

**Duration**: [START] - [END]
**Goal**: [SPRINT GOAL]

### Completed ✅
- #123 - Feature A (5 points)
- #124 - Bug fix B (2 points)
- Total: 7 points

### Not Completed ❌
- #125 - Feature C (8 points) - Moved to next sprint

### Demos
- [Link to recording]

### Metrics
- Planned: 15 points
- Completed: 7 points
- Velocity: 47%

### Key Learnings
- Learning 1
- Learning 2
```

## Tips & Tricks

### Keyboard Shortcuts
- `g` + `p` - Go to Projects
- `g` + `i` - Go to Issues
- `/` - Search
- `c` - Create new issue

### Useful Queries
```bash
# Find all high priority issues
gh issue list --label "🟠 High"

# Find issues assigned to you
gh issue list --assignee @me

# Find issues in current sprint
gh issue list --search "sprint:1"
```

### Integration with VS Code
Install the GitHub Pull Requests extension:
```bash
code --install-extension GitHub.vscode-pull-request-github
```

This allows you to:
- Create issues from TODO comments
- Review PRs in VS Code
- See issue status in editor