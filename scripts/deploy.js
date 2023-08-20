
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
  const tokenRequest = await TokenRequest.deploy("Tokenreceipt","TR","0xe0f837966a3db43De470695a02c131A893FeB5e4","1","0x93737B1246d4c9515c78c97EcD38B12BC85d1E74");
  await tokenRequest.deployed();
  const confirmations = 5; // You can adjust this number as needed
  await Promise.all([
    tokenRequest.deployTransaction.wait(confirmations),
  ]);
  console.log("TokenRequest deployed to:", tokenRequest.address);
  await hre.run("verify:verify", {
    address: tokenRequest.address,
    constructorArguments: ["Tokenreceipt","TR","0xe0f837966a3db43De470695a02c131A893FeB5e4","1","0x93737B1246d4c9515c78c97EcD38B12BC85d1E74"], // Add constructor arguments if any
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