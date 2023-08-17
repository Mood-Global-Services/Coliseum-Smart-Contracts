// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "base64-sol/base64.sol";

interface USDCInterface {
    function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
}

contract TokenRequest is ERC721URIStorage, Ownable {
    uint256 private tokenIdCounter;
    address public usdcTokenAddress; // Address of the USDC token contract
    uint256 public pricePerNFT; // Price in USDC tokens per NFT

     constructor(string memory _name, string memory _symbol, address _usdcTokenAddress, uint256 _pricePerNFT) ERC721(_name, _symbol) {
        tokenIdCounter = 1;
        usdcTokenAddress = _usdcTokenAddress;
        pricePerNFT = _pricePerNFT;
    }

   function requestToken(uint256 _amount) public {
        require(_amount > 0, "Amount must be greater than 0");
        
        // Transfer USDC tokens from user to contract
        USDCInterface usdcToken = USDCInterface(usdcTokenAddress);
        require(usdcToken.transferFrom(msg.sender, address(this), pricePerNFT * _amount), "USDC transfer failed");
        
        uint256 tokenId = tokenIdCounter;
        _mint(msg.sender, tokenId);
        
        string memory svgData = generateSVG(_amount, block.timestamp);
        string memory tokenURI = generateTokenURI(svgData);
        
        _setTokenURI(tokenId, tokenURI);
        
        tokenIdCounter++;
   }
    
    function generateSVG(uint256 _amount, uint256 _timestamp) internal pure returns (string memory) {
        string memory currentTime = formatTimestamp(_timestamp);
        string memory svg = string(
            abi.encodePacked(
                '<svg width="200" height="200" xmlns="http://www.w3.org/2000/svg">',
                '<rect width="100%" height="100%" fill="lightgray" />',
                '<text x="50%" y="40%" dominant-baseline="middle" text-anchor="middle" font-size="16">',
                "Amount: ",
                uintToStr(_amount),
                '</text>',
                '<text x="50%" y="60%" dominant-baseline="middle" text-anchor="middle" font-size="16">',
                "Time: ",
                currentTime,
                '</text>',
                '</svg>'
            )
        );
        return svg;
    }
    
    function generateTokenURI(string memory _svgData) internal pure returns (string memory) {
        string memory json = string(
            abi.encodePacked(
                '{"name": "Token Receipt #',
                '", "description": "It will show amount of tokens requesting alomh with date and time", "image": "data:image/svg+xml;base64,',
                Base64.encode(bytes(_svgData)),
                '"}'
            )
        );
        return string(abi.encodePacked("data:application/json;base64,", Base64.encode(bytes(json))));
    }
    
    function uintToStr(uint256 _value) internal pure returns (string memory) {
        if (_value == 0) {
            return "0";
        }
        uint256 tempValue = _value;
        uint256 digits;
        while (tempValue != 0) {
            digits++;
            tempValue /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (_value != 0) {
            digits--;
            buffer[digits] = bytes1(uint8(48 + _value % 10));
            _value /= 10;
        }
        return string(buffer);
    }
    
    function formatTimestamp(uint256 _timestamp) internal pure returns (string memory) {
        return string(abi.encodePacked(toString(_timestamp), ""));
    }

    function toString(uint256 _value) internal pure returns (string memory) {
        if (_value == 0) {
            return "0";
        }
        uint256 tempValue = _value;
        uint256 digits;
        while (tempValue != 0) {
            digits++;
            tempValue /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (_value != 0) {
            digits--;
            buffer[digits] = bytes1(uint8(48 + _value % 10));
            _value /= 10;
        }
        return string(buffer);
    }
}