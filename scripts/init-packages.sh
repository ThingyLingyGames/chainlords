#!/usr/bin/env bash

# ChainLords Package Initialization Script
# Run this after the main setup script

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

PROJECT_ROOT="/home/dollebrekel/Documents/Web3Dev/chainlords"

print_status() {
    echo -e "${GREEN}✓${NC} $1"
}

print_info() {
    echo -e "${YELLOW}→${NC} $1"
}

echo -e "${BLUE}🎮 ChainLords Package Initialization${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

cd "$PROJECT_ROOT"

# Initialize Contracts Package
echo -e "\n${BLUE}Setting up Smart Contracts package...${NC}"
cd packages/contracts

cat > package.json << 'EOF'
{
  "name": "@chainlords/contracts",
  "version": "0.1.0",
  "private": true,
  "scripts": {
    "compile": "hardhat compile",
    "test": "hardhat test",
    "node": "hardhat node",
    "deploy:local": "hardhat run scripts/deploy.ts --network localhost",
    "deploy:testnet": "hardhat run scripts/deploy.ts --network testnet",
    "verify": "hardhat verify",
    "coverage": "hardhat coverage",
    "lint": "solhint 'contracts/**/*.sol'",
    "prettier": "prettier --write 'contracts/**/*.sol'"
  },
  "devDependencies": {
    "@nomicfoundation/hardhat-toolbox": "^4.0.0",
    "@openzeppelin/contracts": "^5.0.0",
    "@openzeppelin/contracts-upgradeable": "^5.0.0",
    "hardhat": "^2.19.0",
    "solhint": "^4.0.0",
    "prettier-plugin-solidity": "^1.2.0"
  }
}
EOF

# Create Hardhat config
cat > hardhat.config.ts << 'EOF'
import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import * as dotenv from "dotenv";

dotenv.config({ path: "../../.env" });

const config: HardhatUserConfig = {
  solidity: {
    version: "0.8.19",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
  networks: {
    hardhat: {
      chainId: 1337,
    },
    localhost: {
      url: "http://127.0.0.1:8545",
    },
    syscoin: {
      url: process.env.SYSCOIN_RPC_URL || "",
      accounts: process.env.DEPLOYER_PRIVATE_KEY ? [process.env.DEPLOYER_PRIVATE_KEY] : [],
    },
    sepolia: {
      url: process.env.SEPOLIA_RPC_URL || "",
      accounts: process.env.DEPLOYER_PRIVATE_KEY ? [process.env.DEPLOYER_PRIVATE_KEY] : [],
    },
    mumbai: {
      url: process.env.MUMBAI_RPC_URL || "",
      accounts: process.env.DEPLOYER_PRIVATE_KEY ? [process.env.DEPLOYER_PRIVATE_KEY] : [],
    },
  },
  etherscan: {
    apiKey: {
      mainnet: process.env.ETHERSCAN_API_KEY || "",
      sepolia: process.env.ETHERSCAN_API_KEY || "",
      polygon: process.env.POLYGONSCAN_API_KEY || "",
      polygonMumbai: process.env.POLYGONSCAN_API_KEY || "",
    },
  },
};

export default config;
EOF

# Create basic contract structure
mkdir -p contracts/{core,tokens,gameplay,governance,interfaces}
mkdir -p scripts
mkdir -p test

# Create a simple example contract
cat > contracts/tokens/EMPIRE.sol << 'EOF'
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title EMPIRE Token
 * @dev The main utility token for ChainLords game
 */
contract EMPIRE is ERC20, ERC20Burnable, Ownable {
    uint256 public constant MAX_SUPPLY = 1_000_000_000 * 10**18; // 1 billion tokens
    
    constructor() ERC20("EMPIRE", "EMPIRE") Ownable(msg.sender) {
        // Initial mint for game treasury
        _mint(msg.sender, 100_000_000 * 10**18); // 100 million tokens
    }
    
    function mint(address to, uint256 amount) public onlyOwner {
        require(totalSupply() + amount <= MAX_SUPPLY, "Max supply exceeded");
        _mint(to, amount);
    }
}
EOF

# Create deployment script
cat > scripts/deploy.ts << 'EOF'
import { ethers } from "hardhat";

async function main() {
  console.log("Deploying ChainLords contracts...");
  
  // Deploy EMPIRE token
  const EMPIRE = await ethers.getContractFactory("EMPIRE");
  const empire = await EMPIRE.deploy();
  await empire.waitForDeployment();
  
  console.log("EMPIRE token deployed to:", await empire.getAddress());
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
EOF

print_status "Smart Contracts package initialized"

# Initialize Backend Package
echo -e "\n${BLUE}Setting up Backend package...${NC}"
cd ../backend

cat > package.json << 'EOF'
{
  "name": "@chainlords/backend",
  "version": "0.1.0",
  "private": true,
  "scripts": {
    "dev": "nodemon",
    "build": "tsc",
    "start": "node dist/index.js",
    "test": "jest",
    "lint": "eslint src --ext .ts",
    "typecheck": "tsc --noEmit"
  },
  "dependencies": {
    "express": "^4.18.2",
    "cors": "^2.8.5",
    "helmet": "^7.1.0",
    "dotenv": "^16.3.1",
    "jsonwebtoken": "^9.0.2",
    "bcryptjs": "^2.4.3",
    "pg": "^8.11.3",
    "mongoose": "^8.0.0",
    "redis": "^4.6.10",
    "ethers": "^6.9.0",
    "express-rate-limit": "^7.1.0",
    "winston": "^3.11.0"
  },
  "devDependencies": {
    "@types/express": "^4.17.21",
    "@types/node": "^20.10.0",
    "@types/cors": "^2.8.17",
    "@types/bcryptjs": "^2.4.6",
    "typescript": "^5.3.0",
    "nodemon": "^3.0.0",
    "ts-node": "^10.9.0",
    "jest": "^29.7.0",
    "@types/jest": "^29.5.0",
    "eslint": "^8.54.0",
    "@typescript-eslint/eslint-plugin": "^6.13.0",
    "@typescript-eslint/parser": "^6.13.0"
  }
}
EOF

# Create tsconfig.json
cat > tsconfig.json << 'EOF'
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "commonjs",
    "lib": ["ES2022"],
    "outDir": "./dist",
    "rootDir": "./src",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "resolveJsonModule": true,
    "moduleResolution": "node",
    "allowJs": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "noImplicitReturns": true,
    "noFallthroughCasesInSwitch": true
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist"]
}
EOF

# Create nodemon.json
cat > nodemon.json << 'EOF'
{
  "watch": ["src"],
  "ext": "ts",
  "exec": "ts-node src/index.ts",
  "env": {
    "NODE_ENV": "development"
  }
}
EOF

# Create basic server structure
mkdir -p src/{routes,controllers,services,models,middleware,utils}

# Create main server file
cat > src/index.ts << 'EOF'
import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import dotenv from 'dotenv';
import { createServer } from 'http';

// Load environment variables
dotenv.config({ path: '../../.env' });

const app = express();
const port = process.env.PORT || 3001;

// Middleware
app.use(helmet());
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Health check
app.get('/health', (req, res) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

// Create HTTP server
const server = createServer(app);

// Start server
server.listen(port, () => {
  console.log(`⚡️ Server is running at http://localhost:${port}`);
});

export default app;
EOF

print_status "Backend package initialized"

# Initialize Frontend Package
echo -e "\n${BLUE}Setting up Frontend package...${NC}"
cd ../frontend

# Create Next.js app with specific options
cat > package.json << 'EOF'
{
  "name": "@chainlords/frontend",
  "version": "0.1.0",
  "private": true,
  "scripts": {
    "dev": "next dev -p 3000",
    "build": "next build",
    "start": "next start",
    "lint": "next lint",
    "typecheck": "tsc --noEmit"
  },
  "dependencies": {
    "next": "14.0.4",
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "@tanstack/react-query": "^5.12.0",
    "wagmi": "^1.4.0",
    "viem": "^1.19.0",
    "@rainbow-me/rainbowkit": "^1.3.0",
    "ethers": "^6.9.0",
    "framer-motion": "^10.16.0",
    "axios": "^1.6.0",
    "zustand": "^4.4.0",
    "phaser": "^3.70.0"
  },
  "devDependencies": {
    "@types/node": "^20.10.0",
    "@types/react": "^18.2.0",
    "@types/react-dom": "^18.2.0",
    "autoprefixer": "^10.4.0",
    "eslint": "^8.54.0",
    "eslint-config-next": "14.0.4",
    "postcss": "^8.4.0",
    "tailwindcss": "^3.3.0",
    "typescript": "^5.3.0"
  }
}
EOF

# Create Next.js config
cat > next.config.js << 'EOF'
/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  images: {
    domains: ['ipfs.io', 'gateway.pinata.cloud'],
  },
  webpack: (config) => {
    config.resolve.fallback = { fs: false, net: false, tls: false };
    return config;
  },
}

module.exports = nextConfig
EOF

# Create TypeScript config
cat > tsconfig.json << 'EOF'
{
  "compilerOptions": {
    "target": "es5",
    "lib": ["dom", "dom.iterable", "esnext"],
    "allowJs": true,
    "skipLibCheck": true,
    "strict": true,
    "noEmit": true,
    "esModuleInterop": true,
    "module": "esnext",
    "moduleResolution": "bundler",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "jsx": "preserve",
    "incremental": true,
    "plugins": [
      {
        "name": "next"
      }
    ],
    "paths": {
      "@/*": ["./src/*"]
    }
  },
  "include": ["next-env.d.ts", "**/*.ts", "**/*.tsx", ".next/types/**/*.ts"],
  "exclude": ["node_modules"]
}
EOF

# Create Tailwind config
cat > tailwind.config.ts << 'EOF'
import type { Config } from 'tailwindcss'

const config: Config = {
  content: [
    './src/pages/**/*.{js,ts,jsx,tsx,mdx}',
    './src/components/**/*.{js,ts,jsx,tsx,mdx}',
    './src/app/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      colors: {
        'space-dark': '#0a0e27',
        'space-blue': '#1e3a8a',
        'empire-gold': '#fbbf24',
        'battle-red': '#dc2626',
      },
    },
  },
  plugins: [],
}

export default config
EOF

# Create PostCSS config
cat > postcss.config.js << 'EOF'
module.exports = {
  plugins: {
    tailwindcss: {},
    autoprefixer: {},
  },
}
EOF

# Create basic app structure
mkdir -p src/{app,components,hooks,lib,styles,types,utils}

# Create layout
mkdir -p src/app
cat > src/app/layout.tsx << 'EOF'
import type { Metadata } from 'next'
import { Inter } from 'next/font/google'
import './globals.css'

const inter = Inter({ subsets: ['latin'] })

export const metadata: Metadata = {
  title: 'ChainLords: Galactic Empires',
  description: 'Cross-chain idle strategy Web3 game',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en">
      <body className={inter.className}>{children}</body>
    </html>
  )
}
EOF

# Create globals.css
cat > src/app/globals.css << 'EOF'
@tailwind base;
@tailwind components;
@tailwind utilities;

:root {
  --foreground-rgb: 255, 255, 255;
  --background-start-rgb: 10, 14, 39;
  --background-end-rgb: 30, 58, 138;
}

body {
  color: rgb(var(--foreground-rgb));
  background: linear-gradient(
      to bottom,
      transparent,
      rgb(var(--background-end-rgb))
    )
    rgb(var(--background-start-rgb));
}
EOF

# Create home page
cat > src/app/page.tsx << 'EOF'
export default function Home() {
  return (
    <main className="flex min-h-screen flex-col items-center justify-center p-24">
      <h1 className="text-6xl font-bold text-empire-gold mb-8">
        ChainLords
      </h1>
      <p className="text-xl text-gray-300">
        Galactic Empires - Coming Soon
      </p>
    </main>
  )
}
EOF

print_status "Frontend package initialized"

# Initialize Shared Package
echo -e "\n${BLUE}Setting up Shared package...${NC}"
cd ../shared

cat > package.json << 'EOF'
{
  "name": "@chainlords/shared",
  "version": "0.1.0",
  "private": true,
  "main": "dist/index.js",
  "types": "dist/index.d.ts",
  "scripts": {
    "build": "tsc",
    "watch": "tsc -w",
    "clean": "rm -rf dist"
  },
  "devDependencies": {
    "typescript": "^5.3.0"
  }
}
EOF

cat > tsconfig.json << 'EOF'
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "commonjs",
    "lib": ["ES2022"],
    "declaration": true,
    "outDir": "./dist",
    "rootDir": "./src",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist"]
}
EOF

mkdir -p src
cat > src/index.ts << 'EOF'
// Shared types and utilities for ChainLords

export interface GameConfig {
  chainId: number;
  contractAddresses: {
    empire: string;
    gameCore: string;
    nftUnits: string;
  };
}

export interface Player {
  id: string;
  address: string;
  empireName: string;
  resources: Resources;
}

export interface Resources {
  credits: bigint;
  minerals: bigint;
  gas: bigint;
  empire: bigint;
}

export const GAME_CONSTANTS = {
  MAX_FLEET_SIZE: 100,
  BASE_MINING_RATE: 10,
  BATTLE_COOLDOWN: 3600, // 1 hour in seconds
} as const;
EOF

print_status "Shared package initialized"

# Return to root and install dependencies
cd "$PROJECT_ROOT"

echo -e "\n${BLUE}Installing dependencies...${NC}"
npm install
print_status "Root dependencies installed"

# Install sub-package dependencies
echo -e "\n${BLUE}Installing sub-package dependencies...${NC}"
npx lerna bootstrap
print_status "All dependencies installed"

# Final summary
echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✨ Package initialization complete!${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "\n${YELLOW}You can now:${NC}"
echo "1. Start development: npm run dev"
echo "2. Run tests: npm test"
echo "3. Build project: npm run build"
echo -e "\n${GREEN}Happy coding! 🎮${NC}"