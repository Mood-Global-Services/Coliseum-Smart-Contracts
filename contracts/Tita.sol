// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Tita is ERC20, ERC20Burnable, Ownable {
    constructor() ERC20("MyToken", "MTK") {
        _mint(msg.sender, 10000 * 10 ** decimals());
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

   function isTitaHolder(address _address) public view returns (bool) {
        uint256 balance = balanceOf(_address);
        if(balance > 0) {
             return true; 
        } else {
             return false;
        }
      }

        function checkHolderBalance(address _user) public view returns (uint256) {
          if(balanceOf(_user) == 0) {
              return 0;
        } else {
       return balanceOf(_user);
        }
      }
   }