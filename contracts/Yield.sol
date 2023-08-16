// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol"; // Import ERC-721 interface
import "./ChainlinkBalance.sol"; // Import the ChainlinkBalance contract
// Yield distribution contract
contract YieldDistributor {
    IERC721 public tita; // Use the IERC721 interface for the NFT contract
    address public usdc;
    ChainlinkBalance public chainlink;

    constructor(address _tita, address _usdc, address _chainlink) {
        tita = IERC721(_tita);
        usdc = _usdc;
        chainlink = ChainlinkBalance(_chainlink);
    }

  event YieldDistributed(address indexed holder, uint256 amount);

  function distributeYields() external {
    
    
    bytes32 requestId = chainlink.requestBalanceData();
    uint256 ownerBalance = chainlink.balance();
  
    // Calculate annual yield
    uint256 annualYield = 4 / ownerBalance * 100;

    // Take 80% of yield
    uint256 yieldToDistribute = (annualYield * 8) / 10;

    // Distribute to holders 
    for (uint256 i = 0; i < tita.totalSupply(); i++) {
      address holder = tita.tokenOfOwnerByIndex(i);
      uint256 amountOwed = tita.balanceOf(holder) * yieldToDistribute / tita.totalSupply();

      IERC20(usdc).transfer(holder, amountOwed);

      emit YieldDistributed(holder, amountOwed);
    }
  }

}