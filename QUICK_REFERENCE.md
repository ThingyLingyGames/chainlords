# ChainLords Quick Reference

## 🚀 Daily Commands

### Start Development
```bash
# Start all services
npm run dev

# Start specific services
npm run dev:frontend    # http://localhost:3000
npm run dev:backend     # http://localhost:3001
npm run dev:blockchain  # http://localhost:8545

# Check Docker services
docker-compose ps
```

### Git Workflow
```bash
# Create feature branch
git checkout -b feature/issue-NUMBER

# Commit with conventional format
git commit -m "feat: add new feature"
git commit -m "fix: resolve bug"
git commit -m "docs: update README"

# Push and create PR
git push origin feature/issue-NUMBER
gh pr create
```

### Issue Management
```bash
# Create new issue
gh issue create

# View your issues
gh issue list --assignee @me

# View sprint issues
gh issue list --label "sprint-1"

# Start working on issue
gh issue edit NUMBER --add-assignee @me
```

## 📋 Project Links

- 🏠 **Repository**: https://github.com/ThingyLingyGames/chainlords
- 📋 **Project Board**: https://github.com/orgs/ThingyLingyGames/projects/1
- 📝 **Issues**: https://github.com/ThingyLingyGames/chainlords/issues
- 🎯 **Current Sprint**: https://github.com/ThingyLingyGames/chainlords/milestone/1
- 📚 **Documentation**: https://github.com/ThingyLingyGames/chainlords/tree/main/docs

## 🏗️ Project Structure

```
chainlords/
├── packages/
│   ├── contracts/     # Hardhat smart contracts
│   ├── backend/       # Express.js API
│   ├── frontend/      # Next.js web app
│   └── shared/        # Shared types/utils
├── docs/              # All documentation
├── scripts/           # Automation scripts
└── docker-compose.yml # Local services
```

## 🔧 Environment

### Local Services
- **PostgreSQL**: `localhost:5432` (user: chainlords, pass: chainlords_dev)
- **MongoDB**: `localhost:27017` (user: chainlords, pass: chainlords_dev)
- **Redis**: `localhost:6379` (pass: chainlords_dev)

### Test Accounts (Hardhat)
```javascript
// Account #0 (10000 ETH)
0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266
0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80

// Account #1 (10000 ETH)
0x70997970C51812dc3A010C7d01b50e0d17dc79C8
0x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d
```

## 🎯 Current Sprint (Sprint 1)

### Goals
Build foundation with core contracts, basic frontend, and authentication

### Key Tasks
1. **EMPIRE Token** (#14) - 5 points
2. **Landing Page** (#15) - 3 points  
3. **Authentication** (#16) - 5 points
4. **Dev Setup Script** (#17) - 2 points
5. **README Update** (#18) - 1 point

**Total**: 16 story points

### Dates
- Start: January 15, 2025
- End: January 29, 2025

## 📝 Commit Message Format

```
feat: add new feature
fix: resolve bug  
docs: update documentation
style: formatting changes
refactor: code restructuring
test: add tests
chore: maintenance tasks
```

## 🚨 Troubleshooting

### Port Already in Use
```bash
# Find process
lsof -i :PORT_NUMBER

# Kill process
kill -9 PID
```

### Docker Issues
```bash
# Reset everything
docker-compose down -v
docker-compose up -d
```

### Node Modules Issues
```bash
# Clean install
rm -rf node_modules package-lock.json
npm install
```

## 📞 Help & Support

- **Documentation**: [/docs](./docs)
- **Issues**: [GitHub Issues](https://github.com/ThingyLingyGames/chainlords/issues)
- **Discord**: Coming soon
- **Project Status**: [PROJECT_STATUS.md](./docs/PROJECT_STATUS.md)

## 🎮 Ready to Code?

1. Check the [Project Board](https://github.com/orgs/ThingyLingyGames/projects/1)
2. Pick a task from "Sprint Ready"
3. Move to "In Progress"
4. Start coding!

---

*Last updated: January 14, 2025*