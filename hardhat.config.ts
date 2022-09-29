import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

const config: HardhatUserConfig = {
  solidity: "0.8.17",
  networks: {
    bsctestnet: {
      url: 'https://data-seed-prebsc-1-s1.binance.org:8545/',
      from: process.env.ADDRESS,
      accounts: [process.env.SECRET_KEY as string],
    }
  },

  etherscan: {
    apiKey: process.env.BSC_API_KEY,
  }
};

export default config;
