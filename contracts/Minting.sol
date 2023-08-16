// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol"; 
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

interface IERC20Token {
  function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}

contract TokenRequest {

  IERC20 public usdcToken;
  ERC721 public nftToken;
  
  IERC20Token public titaToken;

  address public constant DEAD = 0x000000000000000000000000000000000000dEaD;

  mapping(address => uint) public userTokenBalances;

  constructor(
    address _usdcToken, 
    address _nftToken,
    address _titaToken
  ) {
    usdcToken = IERC20(_usdcToken);
    nftToken = ERC721(_nftToken);
    titaToken = IERC20Token(_titaToken);
  }

  function requestTokens(uint _amount) external payable {
    require(msg.value == _amount * (10**usdcToken.decimals()), "Incorrect USDC amount");

    usdcToken.transferFrom(msg.sender, msg.value);

    userTokenBalances[msg.sender] += _amount;

    nftToken.mint(msg.sender);
  }

  function burnTokens(uint _amount) external {
    require(_amount <= userTokenBalances[msg.sender], "Insufficient balance");

    titaToken.burnFrom(msg.sender, _amount);

    userTokenBalances[msg.sender] -= _amount;
  }

}