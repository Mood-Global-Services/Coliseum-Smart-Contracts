
const { ethers } = require('hardhat');


async function main() {
 
// Deploy Chainlink Contract
  const ChainlinkContract = await hre.ethers.getContractFactory("ChainlinkContract");
  const chainlinkContract = await ChainlinkContract.deploy();
  await chainlinkContract.deployed();
  console.log("ChainlinkContract deployed to:", chainlinkContract.address);

  // Deploy Tita ERC20 token
  const TitaToken = await hre.ethers.getContractFactory("Tita");
  const titaToken = await TitaToken.deploy();
  await titaToken.deployed();
  console.log("Tita ERC20 token deployed to:", titaToken.address);

  // Deploy Cmax ERC20 token
  const CmaxToken = await hre.ethers.getContractFactory("Cmax");
  const cmaxToken = await CmaxToken.deploy();
  await cmaxToken.deployed();
  console.log("Cmax ERC20 token deployed to:", cmaxToken.address);

  // Deploy NFT contract
  const TokenRequest = await hre.ethers.getContractFactory("TokenRequest");
  const tokenRequest = await TokenRequest.deploy("Tokenreceipt","TR","0x65d3090B7bdbe0898d1CfDfEE1ECAf2AD0cCB5a6","1","0x3054484157aA5667717319520c011aF26c8eD75f");
  await tokenRequest.deployed();
  const confirmations = 5; // You can adjust this number as needed
  await Promise.all([
    tokenRequest.deployTransaction.wait(confirmations),
  ]);
  console.log("TokenRequest deployed to:", tokenRequest.address);
  await hre.run("verify:verify", {
    address: tokenRequest.address,
    constructorArguments: ["Tokenreceipt","TR","0x65d3090B7bdbe0898d1CfDfEE1ECAf2AD0cCB5a6","1","0x3054484157aA5667717319520c011aF26c8eD75f"], // Add constructor arguments if any
  });


  //Deploy Rsc Token
  const Rsc = await hre.ethers.getContractFactory("Rsc");
  const rsc = await Rsc.deploy();
  await rsc.deployed();
  console.log("Rsc ERC20 token deployed to:", rsc.address);

  console.log("Deployment completed!");

}


main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });