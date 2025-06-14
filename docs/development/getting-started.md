# Getting Started with ChainLords Development

Welcome to the ChainLords development team! This guide will help you set up your development environment and start contributing to the project.

## Prerequisites

### Required Software
- **Node.js** (v18.0.0 or higher)
- **npm** (v9.0.0 or higher)
- **Git**
- **Docker** and **Docker Compose**
- **VS Code** (recommended) or your preferred IDE

### Recommended VS Code Extensions
Run this command to install recommended extensions:
```bash
code --install-extension dbaeumer.vscode-eslint
code --install-extension esbenp.prettier-vscode
code --install-extension JuanBlanco.solidity
code --install-extension GitHub.copilot
```

## Initial Setup

### 1. Clone the Repository
```bash
git clone git@github.com:ThingyLingyGames/chainlords.git
cd chainlords
```

### 2. Install Dependencies
```bash
# Install root dependencies
npm install

# Install all workspace dependencies
npm install -ws
```

### 3. Environment Configuration
```bash
# Copy environment template
cp .env.example .env

# Edit .env with your values
nano .env
```

Required environment variables:
- Database passwords (or use defaults for development)
- Blockchain RPC URLs (optional for local development)
- API keys for external services

### 4. Start Docker Services
```bash
# Start databases
docker-compose up -d

# Verify services are running
docker-compose ps

# View logs if needed
docker-compose logs -f
```

## Development Workflow

### Running the Application

#### Option 1: Run Everything
```bash
npm run dev
```
This starts:
- Hardhat local blockchain (port 8545)
- Backend API server (port 3001)
- Frontend Next.js app (port 3000)

#### Option 2: Run Services Individually
```bash
# Terminal 1: Blockchain
npm run dev:blockchain

# Terminal 2: Backend
npm run dev:backend

# Terminal 3: Frontend
npm run dev:frontend
```

### Project Structure
```
chainlords/
├── packages/
│   ├── contracts/      # Smart contracts (Hardhat)
│   ├── backend/        # API server (Express.js)
│   ├── frontend/       # Web app (Next.js)
│   └── shared/         # Shared types and utilities
├── docs/               # Documentation
├── scripts/            # Build and deployment scripts
└── docker-compose.yml  # Local services
```

## Development Guidelines

### Code Style
- We use ESLint and Prettier for consistent code formatting
- Run `npm run lint` before committing
- Follow TypeScript best practices
- Write meaningful commit messages

### Git Workflow
1. Create a feature branch from `develop`
   ```bash
   git checkout develop
   git pull origin develop
   git checkout -b feature/your-feature-name
   ```

2. Make your changes and commit
   ```bash
   git add .
   git commit -m "feat: add new feature"
   ```

3. Push and create a pull request
   ```bash
   git push origin feature/your-feature-name
   ```

### Commit Message Convention
We follow the Conventional Commits specification:
- `feat:` New feature
- `fix:` Bug fix
- `docs:` Documentation changes
- `style:` Code style changes (formatting, etc.)
- `refactor:` Code refactoring
- `test:` Adding or updating tests
- `chore:` Maintenance tasks

## Package-Specific Development

### Smart Contracts (packages/contracts)
```bash
cd packages/contracts

# Compile contracts
npm run compile

# Run tests
npm test

# Deploy to local network
npm run deploy:local

# Start local blockchain
npm run node
```

### Backend API (packages/backend)
```bash
cd packages/backend

# Start development server with hot reload
npm run dev

# Run tests
npm test

# Type checking
npm run typecheck
```

### Frontend (packages/frontend)
```bash
cd packages/frontend

# Start development server
npm run dev

# Build for production
npm run build

# Run type checking
npm run typecheck
```

### Shared Package (packages/shared)
```bash
cd packages/shared

# Build the package
npm run build

# Watch for changes
npm run watch
```

## Testing

### Running Tests
```bash
# Run all tests
npm test

# Run specific package tests
npm run test:contracts
npm run test:backend
npm run test:frontend

# Run tests in watch mode
npm test -- --watch
```

### Writing Tests
- Place test files next to the code they test
- Use `.test.ts` or `.spec.ts` extensions
- Follow the AAA pattern (Arrange, Act, Assert)
- Mock external dependencies

## Debugging

### VS Code Debugging
1. Set breakpoints in your code
2. Press F5 to start debugging
3. Use the Debug Console for inspection

### Chrome DevTools
For frontend debugging:
1. Open http://localhost:3000
2. Open DevTools (F12)
3. Use the Sources tab for breakpoints
4. Check Network tab for API calls

### Logging
- Backend: Uses Winston logger
- Frontend: Use `console.log` (removed in production)
- Smart Contracts: Use Hardhat's `console.sol`

## Common Tasks

### Adding a New Package
```bash
# Create new package
mkdir packages/new-package
cd packages/new-package
npm init -y

# Add to root package.json workspaces
```

### Updating Dependencies
```bash
# Update all packages
npm update

# Update specific package
npm update package-name -w @chainlords/backend
```

### Database Migrations
```bash
# Create new migration
npm run migration:create -- --name your-migration-name

# Run migrations
npm run migration:run

# Revert last migration
npm run migration:revert
```

## Troubleshooting

### Common Issues

#### Port Already in Use
```bash
# Find process using port
lsof -i :3000

# Kill process
kill -9 <PID>
```

#### Docker Issues
```bash
# Reset Docker environment
docker-compose down -v
docker-compose up -d
```

#### Node Modules Issues
```bash
# Clean install
rm -rf node_modules package-lock.json
npm install
```

### Getting Help
- Check existing [GitHub Issues](https://github.com/ThingyLingyGames/chainlords/issues)
- Ask in our Discord development channel
- Review the [FAQ](../guides/faq.md)

## Next Steps

1. Read the [Architecture Overview](../architecture/overview.md)
2. Review [Coding Standards](./coding-standards.md)
3. Check out [API Documentation](../api/rest/reference.md)
4. Join our Discord community

Happy coding! 🚀