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
