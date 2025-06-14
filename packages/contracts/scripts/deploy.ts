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
