// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "base64-sol/base64.sol";
import "@thirdweb-dev/contracts/eip/interface/IERC721Supply.sol";

interface USDCInterface {
    function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address _to, uint256 _value) external returns (bool);
    function approve(address _to, uint256 _value) external returns (bool);
}

interface TITAInterface {
    function burnFrom(address _from, uint256 _amount) external;
    function getTokenHolders() external view returns (address[] memory);
    function balanceOf(address account) external view returns (uint256);
    function totalSupply() external view returns (uint256);
}

interface CmaxInterface {
    function burnFrom(address _from, uint256 _amount) external;
    function getTokenHolders() external view returns (address[] memory);
    function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
    function totalSupply() external view returns (uint256);
}

contract TokenRequest is ERC721URIStorage, Ownable, IERC721Supply {
    uint256 private tokenIdCounter;
    address public titaTokenAddress; // Address of the TITA token contract
    address public usdcTokenAddress; // Address of the USDC token contract
    address public cmaxTokenAddress;
    uint256 public pricePerNFT; // Price for requesting tokens
    uint256 public annualDistributionPercentage = 4;

struct TokenRequestInfo {
    address userAddress;
    uint256 amount;
    uint256 timestamp;
}

struct BurnInfo {
    address userAddress;
    uint256 amount;
    uint256 timestamp;
}

struct StakingInfo {
    uint256 amount;
}

mapping(address => StakingInfo) public stakingInfo;

// Mapping to store token request information by token ID
mapping(uint256 => TokenRequestInfo) public tokenRequests;
// Mapping to store burn information by token ID
mapping(uint256 => BurnInfo) public burnInfo;


    // Event with timestamp 
    event TokenRequested(address indexed user, uint256 amount, uint256 timestamp);

    // Timestamp of the last annual distribution
    uint256 public lastAnnualDistributionTimestamp;

     constructor(string memory _name, string memory _symbol,address _cmaxTokenAddress, address _usdcTokenAddress, uint256 _pricePerNFT, address _titaTokenAddress) ERC721(_name, _symbol) {
        tokenIdCounter = 1;
        usdcTokenAddress = _usdcTokenAddress;
        cmaxTokenAddress = _cmaxTokenAddress;
        pricePerNFT = _pricePerNFT;
        titaTokenAddress = _titaTokenAddress;
        lastAnnualDistributionTimestamp = block.timestamp;
    }

    //stake cmax tokens

     function stakeCMAX(uint256 _amount) public {
        require(_amount > 0, "Amount must be greater than 0");
        // Transfer CMAX tokens from user to contract
        // Replace CMAXTokenAddress with the actual address of the CMAX token contract
        CmaxInterface cmaxToken = CmaxInterface(cmaxTokenAddress);
        require(cmaxToken.transferFrom(msg.sender, address(this), _amount), "CMAX transfer failed");

        // Update staking information
        stakingInfo[msg.sender].amount += _amount;
    }

     function totalSupply() public view override returns (uint256) {
     return tokenIdCounter;
  }


// distribute 20% to cmax holders
     function distributeStakingRewards() public onlyOwner {
        // Retrieve the owner's USDC balance
        USDCInterface usdcToken = USDCInterface(usdcTokenAddress);
        uint256 ownerBalance = usdcToken.balanceOf(owner());

        // Calculate the amount to distribute (20% of owner's balance)
        uint256 amountToDistribute = (ownerBalance * 20) / 100;

        // Ensure there are stakers to distribute to
        require(amountToDistribute > 0, "No USDC to distribute or no stakers");

        // Distribute to stakers based on their staked CMAX tokens
        for (uint256 i = 0; i < tokenIdCounter; i++) {
            address staker = ownerOf(i);
            if (stakingInfo[staker].amount > 0) {
                uint256 stakerShare = (stakingInfo[staker].amount * amountToDistribute) / totalStakedCMAX();
                require(usdcToken.transfer(staker, stakerShare), "USDC transfer to staker failed");
            }
        }
    }

    // Function to get the total staked CMAX tokens
    function totalStakedCMAX() public view returns (uint256) {
        uint256 total = 0;
        for (uint256 i = 0; i < tokenIdCounter; i++) {
            address staker = ownerOf(i);
            total += stakingInfo[staker].amount;
        }
        return total;
    }








 function requestToken(address _userAddress, uint256 _amount) public {
    require(_amount > 0, "Amount must be greater than 0");
    
    // Transfer USDC tokens from user to contract
    USDCInterface usdcToken = USDCInterface(usdcTokenAddress);
    require(usdcToken.transferFrom(_userAddress, address(this), pricePerNFT * _amount), "USDC transfer failed");
    
    uint256 tokenId = tokenIdCounter;
    _mint(_userAddress, tokenId);
    
    string memory svgData = generateSVG(_amount, block.timestamp, "Mint Token Request");
    string memory tokenURI = generateTokenURI(svgData);
    
    _setTokenURI(tokenId, tokenURI);
    
    // Store the request information
    tokenRequests[tokenId] = TokenRequestInfo({
        userAddress: _userAddress,
        amount: _amount,
        timestamp: block.timestamp
    });
    
    tokenIdCounter++;
}



   function burnToken(uint256 _amount) public {
    require(_amount > 0, "Amount must be greater than 0");
    
    // Transfer TITA tokens from user to contract
    TITAInterface titaToken = TITAInterface(titaTokenAddress);
    titaToken.burnFrom(msg.sender, _amount);
    
    uint256 tokenId = tokenIdCounter;
    _mint(msg.sender, tokenId);
    
    string memory svgData = generateSVG(_amount, block.timestamp, "Burn Token Request");
    string memory tokenURI = generateTokenURI(svgData);
    
    _setTokenURI(tokenId, tokenURI);
    
    // Store the burn information
    burnInfo[tokenId] = BurnInfo({
        userAddress: msg.sender,
        amount: _amount,
        timestamp: block.timestamp
    });
    
    tokenIdCounter++;
}



// Function to distribute 80% of owner's USDC Balance to all TITA holders monthly/weekly whenever funds are present in the wallet

   function distributeUSDC() public onlyOwner {
    // Retrieve the owner's USDC balance
    USDCInterface usdcToken = USDCInterface(usdcTokenAddress);
    uint256 ownerBalance = usdcToken.balanceOf(owner());

    // Ensure the owner has sufficient funds for distribution
    require(ownerBalance >= 8, "Insufficient USDC balance"); // Ensure at least 8 USDC is available for distribution

    // Calculate the amount to distribute (80% of owner's balance)
    uint256 amountToDistribute = (ownerBalance * 8) / 100;

    // Retrieve the list of TITA token holders and their holdings
    TITAInterface titaToken = TITAInterface(titaTokenAddress);
    address[] memory titaHolders = titaToken.getTokenHolders();

    // Ensure there are holders to distribute to
    require(titaHolders.length > 0, "No TITA token holders to distribute to");

    for (uint256 i = 0; i < titaHolders.length; i++) {
        address holder = titaHolders[i];
        uint256 titaBalance = titaToken.balanceOf(holder);


        // Calculate the share of the distribution for this holder based on their TITA holdings
        uint256 holderShare = (titaBalance * amountToDistribute) / titaToken.totalSupply();

        // Perform the transfer and handle errors
        bool success = usdcToken.transferFrom(owner(), holder, holderShare);
        require(success, "USDC transfer to holder failed");
    }
}


    // Function to distribute 4% of owner's USDC Balance to all TITA holders yearly
    function distributeAnnualUSDC() public onlyOwner {
        // Ensure at least one year has passed since the last annual distribution
        require(block.timestamp >= lastAnnualDistributionTimestamp + 365 days, "Distribution not due yet");

        // Retrieve the owner's USDC balance
        USDCInterface usdcToken = USDCInterface(usdcTokenAddress);
        uint256 ownerBalance = usdcToken.balanceOf(owner());

        // Calculate the amount to distribute (4% of owner's balance)
        uint256 amountToDistribute = (ownerBalance * annualDistributionPercentage) / 100;

        // Retrieve the list of TITA token holders and their holdings
        TITAInterface titaToken = TITAInterface(titaTokenAddress);
        address[] memory titaHolders = titaToken.getTokenHolders(); // Assuming TITA contract has a function to get holders
        for (uint256 i = 0; i < titaHolders.length; i++) {
            address holder = titaHolders[i];

            // Transfer USDC tokens to the TITA holder
            require(usdcToken.transfer(holder, amountToDistribute), "USDC transfer failed");
        }

        // Update the last annual distribution timestamp to the current time
        lastAnnualDistributionTimestamp = block.timestamp;
    }


  // fetch all user addresses with amount amd time who have requested for token
    function getAllTokenRequests() public view returns (TokenRequestInfo[] memory) {
    TokenRequestInfo[] memory requests = new TokenRequestInfo[](tokenIdCounter - 1);
    for (uint256 tokenId = 1; tokenId < tokenIdCounter; tokenId++) {
        TokenRequestInfo memory info = tokenRequests[tokenId];
        if (info.amount > 0 && info.timestamp > 0) {
            requests[tokenId - 1] = info;
        }
    }
    return requests;
    }

  // fetch all user addresses with amount and time who have requested for token burn
function getAllBurnRequests() public view returns (BurnInfo[] memory) {
    BurnInfo[] memory burnRequests = new BurnInfo[](tokenIdCounter - 1);
    for (uint256 tokenId = 1; tokenId < tokenIdCounter; tokenId++) {
        BurnInfo memory info = burnInfo[tokenId];
        if (info.amount > 0 && info.timestamp > 0) {
            burnRequests[tokenId - 1] = info;
        }
    }
    return burnRequests;
}



    function generateSVG(uint256 _amount, uint256 _timestamp, string memory _requestType) internal pure returns (string memory) {
        string memory currentTime = formatTimestamp(_timestamp);
        string memory svg = string(
            abi.encodePacked(
                '<svg width="200" height="200" xmlns="http://www.w3.org/2000/svg">',
                '<rect width="100%" height="100%" fill="lightgray" />',
                '<text x="50%" y="30%" dominant-baseline="middle" text-anchor="middle" font-size="16">',
                _requestType,
                '</text>',
                '<text x="50%" y="50%" dominant-baseline="middle" text-anchor="middle" font-size="16">',
                "Amount: ",
                uintToStr(_amount),
                '</text>',
                '<text x="50%" y="70%" dominant-baseline="middle" text-anchor="middle" font-size="16">',
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
                '", "description": "An NFT with amount and time", "image": "data:image/svg+xml;base64,',
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
