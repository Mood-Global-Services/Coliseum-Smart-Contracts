
const { ethers } = require('hardhat');


async function main() {
 
// Deploy Chainlink Contract
  const ChainlinkContract = await hre.ethers.getContractFactory("ChainlinkContract");
  const chainlinkContract = await ChainlinkContract.deploy();
  await chainlinkContract.deployed();
  console.log("ChainlinkContract deployed to:", chainlinkContract.address);



  // Deploy Tita ERC20 token
  const ColiseumToken = await hre.ethers.getContractFactory("Coliseum");
  const coliseumToken = await ColiseumToken.deploy();
  await coliseumToken.deployed();
  const confirmation = 5; // You can adjust this number as needed
  await Promise.all([
    coliseumToken.deployTransaction.wait(confirmation),
  ]);
  console.log("Coliseum ERC20 token deployed to:", coliseumToken.address);

  await hre.run("verify:verify", {
    address: coliseumToken.address,
    constructorArguments: [],
  });
 

  // Deploy Cmax ERC20 token
  const TitaToken = await hre.ethers.getContractFactory("Tita");
  const titaToken = await TitaToken.deploy();
  await titaToken.deployed();
  console.log("Cmax deployed to:", titaToken.address);
 
  
  // Deploy NFT contract
  const TokenRequest = await hre.ethers.getContractFactory("TokenRequest");
  const tokenRequest = await TokenRequest.deploy("Token Receipt","TB","0xfada9a0f0C5735d3df5ca5B8a5f9B44766f1fCd8","0xe6b8a5cf854791412c1f6efc7caf629f5df1c747", ethers.BigNumber.from("1").div(10)  , "0x00f35860FA16166B0A83E4424807CAe4AFC69Faf");
  await tokenRequest.deployed();
  const confirmations = 5; // You can adjust this number as needed
  await Promise.all([
    tokenRequest.deployTransaction.wait(confirmations),
  ]);
  console.log("TokenRequest deployed to:", tokenRequest.address);
  await hre.run("verify:verify", {
    address: tokenRequest.address,
    constructorArguments: ["Token Receipt","TB","0xfada9a0f0C5735d3df5ca5B8a5f9B44766f1fCd8","0xe6b8a5cf854791412c1f6efc7caf629f5df1c747", ethers.BigNumber.from("1").div(10) , "0x00f35860FA16166B0A83E4424807CAe4AFC69Faf"], // Add constructor arguments if any
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