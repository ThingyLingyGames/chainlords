# ChainLords Project Setup Guide

## 🚀 Quick Setup (5 minutes)

### Option 1: Automated Setup
```bash
# 1. Add GitHub permissions (one-time)
gh auth refresh -h github.com -s project,read:project,write:org,admin:org

# 2. Run the setup script
./setup-commands.sh
```

### Option 2: Manual Web Setup

1. **Create Project Board**
   - Go to: https://github.com/orgs/ThingyLingyGames/projects/new
   - Select: "Board" template
   - Name: "ChainLords Development"
   - Click: "Create project"

2. **Set Up Columns** (drag to reorder)
   - 📋 Backlog
   - 🎯 Sprint Ready
   - 🚀 In Progress
   - 👀 In Review
   - ✅ Done

3. **Add Custom Fields**
   Click ⚙️ → Fields → + New field:
   
   - **Story Points**
     - Type: Number
     - Name: Story Points
   
   - **Priority**
     - Type: Single select
     - Name: Priority
     - Options:
       - 🔴 Critical
       - 🟠 High
       - 🟡 Medium
       - 🟢 Low
   
   - **Sprint**
     - Type: Text
     - Name: Sprint

4. **Add Issues to Project**
   - Click: + Add items
   - Search: `repo:ThingyLingyGames/chainlords`
   - Select: All
   - Click: Add selected items

5. **Configure Automation**
   - Go to: ⚙️ → Workflows
   - Enable: "Item added to project"
   - Enable: "Item closed"

## ✅ Setup Complete!

Your project board is now ready at:
https://github.com/orgs/ThingyLingyGames/projects/1

### Quick Links
- 📋 [Project Board](https://github.com/orgs/ThingyLingyGames/projects/1)
- 🐙 [Repository](https://github.com/ThingyLingyGames/chainlords)
- 📝 [Issues](https://github.com/ThingyLingyGames/chainlords/issues)
- 📚 [Documentation](https://github.com/ThingyLingyGames/chainlords/tree/main/docs)

### Daily Workflow
```bash
# Create new issue
gh issue create

# View your issues
gh issue list --assignee @me

# Start working on issue #5
gh issue edit 5 --add-assignee @me
gh issue comment 5 --body "Starting work on this"

# Create PR when done
git checkout -b feature/issue-5
# ... make changes ...
git push origin feature/issue-5
gh pr create --title "Fix: Issue #5" --body "Closes #5"
```

## 📱 Mobile Access
1. Download [GitHub Mobile](https://github.com/mobile)
2. Sign in with your account
3. Navigate to Projects tab
4. Access your board on the go!

## 🎯 Sprint 1 Goals
Based on the created issues:
1. ✅ Implement EMPIRE token contract
2. ✅ Create landing page with wallet connection
3. ✅ Set up authentication system
4. ✅ Create development environment setup script
5. ✅ Write comprehensive README

---

Happy coding! 🚀