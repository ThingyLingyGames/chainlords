# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

ChainLords: Galactic Empires - A cross-chain idle strategy Web3 game built on Syscoin with multi-chain integration (Ethereum, Polygon).

## Project Status

Currently in planning phase with comprehensive documentation. No code implementation yet.

## Essential Commands

### Initial Project Setup (when implemented)
```bash
# Install dependencies
npm install

# Run development environment  
npm run dev  # Runs all services concurrently

# Individual services
npm run dev:blockchain  # Start local Hardhat node
npm run dev:backend     # Start backend API server
npm run dev:frontend    # Start Next.js frontend

# Testing
npm run test           # Run all tests
npm run test:contracts # Test smart contracts
npm run test:backend   # Test backend
npm run test:frontend  # Test frontend

# Build for production
npm run build

# Deploy contracts locally
npm run deploy:local
```

### Docker Development
```bash
# Start all services
docker-compose up -d

# Stop services
docker-compose down

# View logs
docker-compose logs -f
```

## Architecture Overview

### Tech Stack (Planned)
- **Frontend**: Next.js, React, TypeScript, Tailwind CSS, Wagmi (Web3 hooks)
- **Backend**: Express.js, Node.js, PostgreSQL, MongoDB, Redis
- **Blockchain**: Hardhat, Solidity, Ethers.js
- **Game Engine**: Phaser 3 (2D) or Three.js (3D)
- **Infrastructure**: Docker, GitHub Actions, Vercel/Railway

### Project Structure (Planned)
```
chainlords/
├── packages/
│   ├── contracts/      # Smart contracts (Hardhat)
│   ├── backend/        # API server (Express)
│   ├── frontend/       # Web app (Next.js)
│   └── shared/         # Shared types/utils
├── docs/               # Documentation
├── scripts/            # Build/deploy scripts
└── docker-compose.yml  # Local development
```

### Key Features
1. **Cross-chain gameplay** across Syscoin, Ethereum, and Polygon
2. **NFT-based units** with upgradeable stats
3. **Play-to-earn** with EMPIRE token (SPT)
4. **DAO governance** for community-driven development
5. **Idle mechanics** combined with strategic gameplay

## Development Approach

### AI-Powered Development Strategy
- Solo developer approach with heavy AI assistance
- Budget: <$500/month until demo ready
- Timeline: 6 months to production demo
- Uses GitHub Copilot, Claude, and other AI tools for productivity

### Development Phases
1. **Months 1-3**: Local development setup and core functionality
2. **Months 4-6**: Testnet deployment and demo preparation
3. **Months 7-9**: Official launch
4. **Months 10-12**: Post-launch growth and stabilization

## Important Context

### Cross-Chain Implementation
- Primary hub on Syscoin NEVM for core game logic
- Asset mirroring on other chains
- Multi-signature bridges for security
- State synchronization across chains

### Testing Networks
- Local: Hardhat network with test accounts
- Testnets: Syscoin testnet, Ethereum Sepolia, Polygon Mumbai

### Community Building
- Discord-first approach
- Ambassador program planned
- Strong focus on organic growth
- Educational content strategy

## Development Guidelines

1. **Security First**: All smart contracts must be audited before mainnet
2. **Cross-chain Compatibility**: Test all features on multiple chains
3. **Gas Optimization**: Minimize transaction costs for players
4. **User Experience**: Prioritize smooth onboarding for Web3 newcomers
5. **Documentation**: Keep all documentation up-to-date as development progresses

## Current Planning Documents

- `Developmentp_Plan.txt`: Solo developer setup and roadmap
- `DevOpsTools.txt`: Free DevOps tools and project management
- `Uitgebreide_Gameplan_Web3Game.txt`: Detailed game design document
- `AI_Powered_Scaling.txt`: AI-assisted development strategy
- `Community_Building_Plan.txt`: Community growth strategy

When starting implementation, refer to these documents for detailed specifications and strategies.