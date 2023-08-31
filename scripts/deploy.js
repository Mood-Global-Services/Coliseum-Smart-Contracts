
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
  const confirmation = 5; // You can adjust this number as needed
  await Promise.all([
    titaToken.deployTransaction.wait(confirmation),
  ]);
  console.log("Tita ERC20 token deployed to:", titaToken.address);

  await hre.run("verify:verify", {
    address: titaToken.address,
    constructorArguments: [],
  });
 

  // Deploy Cmax ERC20 token
  const CmaxToken = await hre.ethers.getContractFactory("Cmax");
  const cmaxToken = await CmaxToken.deploy();
  await cmaxToken.deployed();
  console.log("Cmax ERC20 token deployed to:", cmaxToken.address);
 

  // Deploy NFT contract
  const TokenRequest = await hre.ethers.getContractFactory("TokenRequest");
  const tokenRequest = await TokenRequest.deploy("Token Receipt","TB","0xe6b8a5CF854791412c1f6EFC7CAf629f5Df1c747","0xe6b8a5CF854791412c1f6EFC7CAf629f5Df1c747","1", "0x00f35860FA16166B0A83E4424807CAe4AFC69Faf");
  await tokenRequest.deployed();
  const confirmations = 5; // You can adjust this number as needed
  await Promise.all([
    tokenRequest.deployTransaction.wait(confirmations),
  ]);
  console.log("TokenRequest deployed to:", tokenRequest.address);
  await hre.run("verify:verify", {
    address: tokenRequest.address,
    constructorArguments: ["Token Receipt","TB","0xe6b8a5CF854791412c1f6EFC7CAf629f5Df1c747","0xe6b8a5CF854791412c1f6EFC7CAf629f5Df1c747","1", "0x00f35860FA16166B0A83E4424807CAe4AFC69Faf"], // Add constructor arguments if any
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