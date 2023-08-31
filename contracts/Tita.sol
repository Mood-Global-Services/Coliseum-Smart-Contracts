// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Tita is ERC20, ERC20Burnable, Ownable {
    address[] public tokenHolders; // Array to store token holders' addresses

    constructor() ERC20("MyToken", "MTK") {
        _mint(msg.sender, 10000 * 10 ** decimals());
        tokenHolders.push(msg.sender); // Add the contract deployer as the initial token holder
    }

    function mint(address to, uint256 amount) public {
        _mint(to, amount);
        if (balanceOf(to) > 0) {
            tokenHolders.push(to); // Add the address to the token holders array
        }
    }

    // Function to get the array of all holder addresses
    function getTokenHolders() public view returns (address[] memory) {
        return tokenHolders;
    }
}
