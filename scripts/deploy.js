
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

  // Deploy ERC4907 contract
  const ERC4907 = await hre.ethers.getContractFactory("ERC4907");
  const erc4907 = await ERC4907.deploy("ERC4907", "ERC");
  await erc4907.deployed();
  console.log("ERC4907 deployed to:", erc4907.address);


  //Deploy Rsc Token
  const Rsc = await hre.ethers.getContractFactory("ERC4907");
  const rsc = await Rsc.deploy("ERC4907", "ERC");
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