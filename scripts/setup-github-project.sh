#!/usr/bin/env bash

# GitHub Project Setup Script for ChainLords
# This script creates and configures a GitHub Project board

set -e

# Configuration
OWNER="ThingyLingyGames"
REPO="chainlords"
PROJECT_TITLE="ChainLords Development"

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

echo -e "${BLUE}🚀 Setting up GitHub Project for $OWNER/$REPO${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

# Check if gh is installed
if ! command -v gh &> /dev/null; then
    print_error "GitHub CLI (gh) is not installed"
    print_info "Please install it first"
    exit 1
fi

# Check if authenticated
if ! gh auth status &> /dev/null; then
    print_error "Not authenticated with GitHub"
    print_info "Please run: gh auth login"
    exit 1
fi

# Create labels if they don't exist
echo -e "\n${BLUE}Creating labels...${NC}"

create_label() {
    local name=$1
    local color=$2
    local description=$3
    
    if gh label create "$name" --repo "$OWNER/$REPO" --color "$color" --description "$description" 2>/dev/null; then
        print_status "Created label: $name"
    else
        print_info "Label already exists: $name"
    fi
}

# Create component labels
create_label "smart-contracts" "1f77b4" "Smart contract related"
create_label "backend" "0e8a16" "Backend API related"
create_label "frontend" "7057ff" "Frontend application"
create_label "infrastructure" "b60205" "Infrastructure and DevOps"
create_label "documentation" "0075ca" "Documentation improvements"

# Create type labels
create_label "epic" "3E4B9E" "Large feature spanning multiple tasks"
create_label "spike" "ee9900" "Research or investigation needed"
create_label "debt" "e99695" "Technical debt"

# Create priority labels
create_label "priority:critical" "d73a4a" "Critical priority"
create_label "priority:high" "e56336" "High priority"
create_label "priority:medium" "fbca04" "Medium priority"
create_label "priority:low" "0e8216" "Low priority"

# Create sprint labels
create_label "sprint-1" "bcf3ff" "Sprint 1"
create_label "sprint-2" "bcf3ff" "Sprint 2"
create_label "sprint-ready" "c5def5" "Ready for next sprint"

# Create milestones
echo -e "\n${BLUE}Creating milestones...${NC}"

create_milestone() {
    local title=$1
    local description=$2
    local due_date=$3
    
    response=$(gh api repos/$OWNER/$REPO/milestones \
        --method POST \
        --field title="$title" \
        --field description="$description" \
        --field due_on="$due_date" 2>&1) || true
    
    if [[ $response == *"already_exists"* ]]; then
        print_info "Milestone already exists: $title"
    else
        print_status "Created milestone: $title"
    fi
}

create_milestone "MVP - Local Demo" "Basic playable version running locally" "2025-03-31T23:59:59Z"
create_milestone "Alpha - Testnet" "First version deployed to testnet" "2025-05-31T23:59:59Z"
create_milestone "Beta - Public Test" "Feature-complete beta for public testing" "2025-07-31T23:59:59Z"
create_milestone "v1.0 - Mainnet" "Production release on mainnet" "2025-09-30T23:59:59Z"

# Create initial epic issues
echo -e "\n${BLUE}Creating epic issues...${NC}"

create_epic() {
    local title=$1
    local body=$2
    local labels=$3
    
    gh issue create \
        --repo "$OWNER/$REPO" \
        --title "$title" \
        --body "$body" \
        --label "$labels" || print_info "Issue might already exist: $title"
}

create_epic "Epic: Core Smart Contracts" \
"## Smart Contract Development

### Contracts to Develop:
- [ ] EMPIRE Token (ERC20)
- [ ] Game NFTs (ERC1155)
- [ ] Resource Management
- [ ] Battle System
- [ ] Staking Contract
- [ ] Treasury Contract
- [ ] Bridge Contracts

### Requirements:
- Full test coverage
- Gas optimization
- Security audit ready
- Multi-chain compatible" \
"epic,smart-contracts"

create_epic "Epic: Game Frontend" \
"## Frontend Application Development

### Features to Implement:
- [ ] Landing page
- [ ] Wallet connection (RainbowKit)
- [ ] Game dashboard
- [ ] Resource management UI
- [ ] Battle interface
- [ ] Fleet builder
- [ ] Marketplace
- [ ] Alliance system
- [ ] Leaderboards

### Tech Stack:
- Next.js 14
- TypeScript
- Tailwind CSS
- Phaser 3 for game graphics
- Wagmi for Web3 integration" \
"epic,frontend"

create_epic "Epic: Backend Services" \
"## Backend API Development

### Services to Build:
- [ ] Authentication (JWT + Web3)
- [ ] Game state management
- [ ] Resource calculation engine
- [ ] Battle simulation
- [ ] Matchmaking system
- [ ] WebSocket for real-time updates
- [ ] Caching layer
- [ ] Analytics service

### Tech Stack:
- Express.js
- PostgreSQL
- MongoDB
- Redis
- WebSocket" \
"epic,backend"

create_epic "Epic: Infrastructure Setup" \
"## Infrastructure and DevOps

### Tasks:
- [ ] Production environment setup
- [ ] CI/CD pipelines
- [ ] Monitoring and alerting
- [ ] Auto-scaling configuration
- [ ] Backup strategies
- [ ] Security hardening
- [ ] CDN setup
- [ ] Multi-region deployment

### Tools:
- Docker
- GitHub Actions
- Vercel/Railway
- Grafana
- Sentry" \
"epic,infrastructure"

# Create Sprint 1 tasks
echo -e "\n${BLUE}Creating Sprint 1 tasks...${NC}"

create_task() {
    local title=$1
    local body=$2
    local labels=$3
    local milestone=$4
    
    gh issue create \
        --repo "$OWNER/$REPO" \
        --title "$title" \
        --body "$body" \
        --label "$labels" \
        --milestone "$milestone" || print_info "Issue might already exist: $title"
}

create_task "feat: Implement EMPIRE token contract" \
"## Task Description
Create the main EMPIRE token contract with standard ERC20 functionality plus game-specific features.

## Acceptance Criteria
- [ ] Standard ERC20 functions implemented
- [ ] Minting capability (only by game contracts)
- [ ] Burning mechanism for game sinks
- [ ] Maximum supply cap enforced
- [ ] Comprehensive test suite
- [ ] Gas optimized

## Technical Notes
- Use OpenZeppelin contracts as base
- Implement role-based access control
- Add pause functionality for emergencies

**Story Points**: 5" \
"enhancement,smart-contracts,sprint-1" \
"MVP - Local Demo"

create_task "feat: Create landing page with wallet connection" \
"## Task Description
Build the main landing page with Web3 wallet integration.

## Acceptance Criteria
- [ ] Responsive design implemented
- [ ] Hero section with game preview
- [ ] Feature highlights
- [ ] Wallet connection button
- [ ] Support for MetaMask, WalletConnect
- [ ] Error handling for wallet issues
- [ ] Loading states

## Design Notes
- Follow the space theme
- Use provided color palette
- Smooth animations
- Mobile-first approach

**Story Points**: 3" \
"enhancement,frontend,sprint-1" \
"MVP - Local Demo"

create_task "feat: Set up authentication system" \
"## Task Description
Implement authentication combining traditional JWT with Web3 signatures.

## Acceptance Criteria
- [ ] JWT token generation and validation
- [ ] Web3 signature verification
- [ ] Session management with Redis
- [ ] Auth middleware for protected routes
- [ ] Refresh token mechanism
- [ ] Logout functionality
- [ ] Tests for all auth flows

## Security Considerations
- Implement rate limiting
- Secure token storage
- CORS configuration
- Input validation

**Story Points**: 5" \
"enhancement,backend,sprint-1" \
"MVP - Local Demo"

create_task "feat: Create development environment setup script" \
"## Task Description
Improve the setup script to include all development dependencies and configurations.

## Acceptance Criteria
- [ ] One-command setup for new developers
- [ ] Check and install all prerequisites
- [ ] Configure git hooks
- [ ] Set up local blockchain
- [ ] Import test accounts
- [ ] Seed initial data
- [ ] Health check at the end

**Story Points**: 2" \
"enhancement,infrastructure,sprint-1" \
"MVP - Local Demo"

create_task "docs: Write comprehensive README" \
"## Task Description
Create a detailed README that helps new developers and users understand the project.

## Acceptance Criteria
- [ ] Project overview and vision
- [ ] Tech stack explanation
- [ ] Setup instructions
- [ ] Development workflow
- [ ] Contributing guidelines link
- [ ] License information
- [ ] Community links
- [ ] Status badges

**Story Points**: 1" \
"documentation,sprint-1" \
"MVP - Local Demo"

echo -e "\n${BLUE}Creating project board...${NC}"
print_info "Please create the project board manually at:"
print_info "https://github.com/orgs/$OWNER/projects/new"
print_info ""
print_info "Recommended columns:"
print_info "- 📋 Backlog"
print_info "- 🎯 Sprint Ready" 
print_info "- 🚀 In Progress"
print_info "- 👀 In Review"
print_info "- ✅ Done"

echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✨ GitHub setup complete!${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "\n${YELLOW}Next steps:${NC}"
echo "1. Create the project board at the link above"
echo "2. Add the created issues to the project"
echo "3. Configure automation rules in project settings"
echo "4. Start your first sprint planning!"
echo -e "\n${GREEN}Happy coding! 🚀${NC}"