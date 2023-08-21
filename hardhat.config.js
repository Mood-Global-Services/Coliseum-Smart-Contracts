const { task } = require("hardhat/config");

require("@nomiclabs/hardhat-ethers");
require("@nomiclabs/hardhat-etherscan");


const dotenv = require("dotenv").config();
const privateKey = process.env.PRIVATE_KEY;
const urlEndpoint = process.env.RPC_URL;
const apiKey = process.env.POLYGONSCAN_API_KEY


task("accounts", "Prints The List Of Accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  networks: {
    localhost: {
      url: "http://127.0.0.1:8545",
    },
    hardhat: {
      // See its defaults
    },
    mantleTestnet: {
      url: "https://rpc.testnet.mantle.xyz/",
      chainId: 5001,
      accounts: [privateKey],
    },
    mumbai: {
      url: "https://polygon-mumbai.g.alchemy.com/v2/vgLoYnAJMxYqmAnhONB0KZeegakLZceQ",
      chainId: 80001,
      accounts: [privateKey],
    },
  },
  solidity: {
    version: "0.8.10",
    settings: {
      optimizer: {
        enabled: true,
        runs: 500,
      },
    },
  },
   etherscan: {
     apiKey: {
       polygonMumbai: apiKey,
     },
  //   customChains: [
  //     {
  //       network: "polygonMumbai",
  //       chainId: 80001,
  //       urls: {
  //         apiURL: "https://api-testnet.polygonscan.com",
  //         browserURL: "https://mumbai.polygonscan.com",
  //       },
  //     },
  //   ],
   },
};
