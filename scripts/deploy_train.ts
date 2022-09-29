// scripts/deploy_upgradeable_box.js
const { ethers, upgrades } = require("hardhat");

async function main() {
    const Train = await ethers.getContractFactory("Train");
    console.log("Deploying initializer...");
    // console.log(upgrades);
    const train = await upgrades.deployProxy(Train, [process.env.MAX_TOTAL_SUPPLY], {
        initializer: "initialize",
    });
    await train.deployed();
    console.log("initializer deployed to:", train.address);
}

main();