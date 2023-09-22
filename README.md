# Coliseum-Smart-Contracts
Smarts Contracts Repo



Chainlink smart contract to fetch Intercative Broker Balance:

Purpose: This contract is designed to interact with Chainlink, a service that connects smart contracts to real-world data, like getting the balance from an external source(Intercative Broker account).

Key Components:

Import Statements:

This code imports some pre-written code (smart contracts) from Chainlink and Solidity.
Contract Definition:

It defines a new smart contract named ChainlinkContract.
Inheritance:

ChainlinkClient and ConfirmedOwner are inherited. This means the new contract has access to functions and variables defined in those contracts.
State Variables:

balance: Stores the balance data that will be retrieved.
jobId: A unique identifier for a Chainlink job.
fee: The cost in Chainlink tokens to use the Chainlink service.
Event:

RequestBalance: An event that gets triggered when the balance is requested.
Constructor:

This special function is called when the contract is deployed.
It sets some initial values for Chainlink, like the Chainlink token address, Oracle address, jobId, and fee.
Function - requestBalanceData:

This function requests the balance data.
It builds a Chainlink request specifying the job, where to send the response, and how to process it.
It then sends this request to Chainlink by paying a fee.
Function - fulfill:

This function is called by Chainlink when it receives the data.
It stores the received balance and emits an event to notify others.
Function - withdrawLink:

Only the owner (the person who deployed the contract) can use this function.
It allows the owner to withdraw any unused Chainlink tokens from the contract.
Overall: This contract is designed to fetch balance data from an external source using Chainlink. It has functions to request the balance, receive and store it, and allows the owner to withdraw any leftover Chainlink tokens. This can be useful for decentralized applications (dApps) that need reliable real-world data.




<-------------------------------------------------------->



Token contract with mint/burn and yield distribution :

Token Request Smart Contract
This smart contract is designed to manage the creation and distribution of two types of tokens: CMAX and TITA tokens. It also interacts with a USDC token for financial transactions. Let's break down the main features of this contract in simple terms:

1. Tokens and Staking
CMAX Tokens
This contract allows users to stake CMAX tokens. Staking means users lock their CMAX tokens in this contract for a specific purpose.
TITA Tokens
Users can also burn their TITA tokens. Burning tokens means they destroy them, and in return, they receive a special NFT (non-fungible token).

2. NFT (Non-Fungible Token) Generation
The contract generates unique NFTs as receipts for certain actions:
When users request tokens (Mint Request).
When users burn TITA tokens (Burn Token Request).

3. Token Distribution
CMAX Staking Rewards
The owner of this contract can distribute 20% of their USDC balance to users who have staked CMAX tokens. This distribution happens when the owner decides.
USDC Distribution to TITA Holders
The owner can distribute 80% of their USDC balance to all TITA token holders. This distribution occurs periodically when the owner initiates it.
Annual USDC Distribution to TITA Holders
There is also an annual distribution of 4% of the owner's USDC balance to TITA token holders. This happens once a year and is automatic.

4. Token Requests and Burns
Token Requests
Users can request tokens by paying a certain amount of USDC. This action generates an NFT with details like the amount, timestamp, and "Mint Request" label.
Token Burns
Users can burn their TITA tokens to receive an NFT as proof of the burn. The NFT contains details about the burn, such as the amount, timestamp, and "Burn Token Request" label.

5. Token Information
Users can retrieve information about all token requests and burns made in the past. This helps users track their actions and token history.


In summary, this smart contract serves as a tool for managing CMAX and TITA tokens, enabling users to stake, request, and burn tokens while providing transparency through NFT receipts and distributing rewards to token holders. It also has features for distributing USDC to token holders, both periodically and annually.





<-------------------------------------------------------->


Cmax , Tita and Rsc contract

This are all ERC20 tokens made for minting , burning , transfering etc



<-------------------------------------------------------->


Scripts/Deploy file:

Purpose of the Code
The purpose of this code is to deploy several Ethereum smart contracts on the blockchain. These contracts are nft , rsc, cmax, chainlink and other contracts

Step 1: Deploy ChainlinkContract
The code starts by deploying a contract called ChainlinkContract.
Think of this contract as a bridge to Chainlink, a service that provides real-world data to smart contracts.
The deployed contract's address is printed to the console for reference.
Step 2: Deploy Tita ERC20 Token
The code deploys a custom token contract called Tita.
This token is similar to cryptocurrencies like Ethereum or Bitcoin, but it's custom-made for a specific project.
The deployed token contract's address is printed to the console.
Step 3: Deploy Cmax ERC20 Token
Similar to step 2, the code deploys another custom token contract called Cmax.
Again, the deployed token contract's address is printed to the console.
Step 4: Deploy NFT Contract (TokenRequest)
The code deploys a contract called TokenRequest.
This contract manages the creation and distribution of NFTs (unique digital collectibles) in exchange for specific actions like requesting or burning tokens.
Various parameters, like the contract's name, symbol, and addresses of other tokens, are provided during deployment.
The deployed contract's address is printed, and then a verification process is initiated to ensure its correctness on the blockchain.
Step 5: Deploy Rsc ERC20 Token
Similar to steps 2 and 3, the code deploys another custom token contract called Rsc.
Once deployed, the address of the Rsc token contract is printed to the console.

add the address of the required tokens and run this command below

> npm run deploy

Conclusion
In summary, this code automates the deployment of several smart contracts on the Ethereum blockchain. These contracts play different roles, from interacting with external services like Chainlink to creating custom tokens and managing NFTs. The printed contract addresses are essential for interacting with these contracts on the blockchain.





<-------------------------------------------------------->


.env file

In this file you need to add your private key of your metamask wallet and the blockchain network you want to
deploy your smart contract that network api key is required for smart contract verification


<-------------------------------------------------------->


hardhat.config.js file :

Purpose of the Configuration
The purpose of this configuration file is to set up the development environment for Ethereum smart contract development using the Hardhat framework. It also includes settings for interacting with the Polygon (formerly Matic) blockchain and Etherscan, a service for exploring Ethereum-based blockchains.

1. Importing Dependencies
The code starts by importing necessary dependencies like Hardhat and Etherscan.
It also loads environment variables using dotenv. Environment variables are used to store sensitive information like private keys and API keys securely.
2. Task Definition
A task named "accounts" is defined. This task is not directly related to smart contracts but is useful for listing Ethereum accounts during development.
3. Configuration Object
The following settings are defined within the configuration object:

Networks
localhost: This configuration connects to a local Ethereum network running on the computer.
hardhat: This is the default network provided by the Hardhat framework, typically used for local development and testing.
mantleTestnet: Connects to the Mantle testnet, a blockchain network. It uses a specific URL and private key for account access.
mumbai: Connects to the Polygon Mumbai testnet. Polygon is a scaling solution for Ethereum. This network uses a specific URL and private key.
Solidity
This section specifies the version of the Solidity programming language to be used for smart contract development. It also enables an optimizer to improve contract efficiency.
Etherscan API Key
The etherscan section includes an API key for Etherscan. Etherscan is a tool to explore and verify Ethereum transactions and contracts.
It specifies the API key for the Polygon Mumbai network.
Conclusion
In summary, this configuration file sets up the development environment for Ethereum and Polygon smart contract development using the Hardhat framework. It defines network connections, Solidity version, and an API key for Etherscan. It also includes a task for listing Ethereum accounts. This configuration is crucial for seamless development and testing of smart contracts.
