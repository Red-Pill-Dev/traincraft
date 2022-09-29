train-chain
Make sure to use node v16.15.1

Run npm install in project root directory

Create .env file

```
BSC_API_KEY={YOUR_ETHERSCAN_API_KEY}, required (for test and scripts)

ADDRESS={YOUR_OWNER_ADDRESS}, not required
SECRET_KEY={YOUR_OWNER_PRIVATE_KEY} required (for all scripts)

MAX_TOTAL_SUPPLY={MAX_TOTAL_SUPPLY} required (for options contract)
```


deploy contract:

-- npx hardhat compile
-- npx hardhat run --network bsctestnet scripts/deploy_train.ts


Contract description:

1. The TrainUpgradeableV1 token contract is compatible with the ERC20/BEP20 standards.
The @openzeppelin ERC20Upgradeable contract was taken as the basis with the added ability to pause the contract and add or remove addresses to and from the blacklist. The contract is deployed through a proxy using the @openzeppelin/hardhat-upgrades library.
