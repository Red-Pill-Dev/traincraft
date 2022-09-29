const { ethers, upgrades } = require("hardhat");

const PROXY = process.env.PROXY_ADDRESS;

async function main() {
    const Train = await ethers.getContractFactory("TrainV2");
    console.log("Upgrading Train...");
    await upgrades.upgradeProxy(PROXY, Train);
    console.log("Train upgraded");
}

main();