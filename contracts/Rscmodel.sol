// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";
import "@chainlink/contracts/src/v0.8/ConfirmedOwner.sol";
import "./Rsc.sol"; // Import the Rsc token contract

contract ChainlinkRsc is ChainlinkClient, ConfirmedOwner {
    using Chainlink for Chainlink.Request;

    uint256 public balance;
    bytes32 private jobId;
    uint256 private fee;
    Rsc public rscToken; // Reference to the Rsc token contract

    event RequestBalance(bytes32 indexed requestId, uint256 balance);

    constructor(address _rscTokenAddress) ConfirmedOwner(msg.sender) {
        setChainlinkToken(0x779877A7B0D9E8603169DdbD7836e478b4624789);
        setChainlinkOracle(0x6090149792dAAeE9D1D568c9f9a6F6B46AA29eFD);
        jobId = "ca98366cc7314957b8c012c72f05aeeb";
        fee = (1 * LINK_DIVISIBILITY) / 10;
        rscToken = Rsc(_rscTokenAddress);
    }

    function requestBalanceData() public returns (bytes32 requestId) {
        Chainlink.Request memory req = buildChainlinkRequest(
            jobId,
            address(this),
            this.fulfill.selector
        );

        req.add(
            "get",
            "http://localhost:5000/api/count" //this link won't work because we are using localhost so need to deploy our api in any hosting server to get https link
        );

        req.add("path", "data.balance.amount");

        int256 timesAmount = 1;
        req.addInt("times", timesAmount);

        // Sends the request
        return sendChainlinkRequest(req, fee);
    }

    function fulfill(
        bytes32 _requestId,
        uint256 _balance
    ) public recordChainlinkFulfillment(_requestId) {
        emit RequestBalance(_requestId, _balance);
        balance = _balance;
        mintTokens(_balance); // Mint tokens after fetching the balance
    }

    function mintTokens(uint256 _balance) private {
        rscToken.mint(owner(), _balance); // Mint tokens to the owner's address
    }

    function withdrawLink() public onlyOwner {
        LinkTokenInterface link = LinkTokenInterface(chainlinkTokenAddress());
        require(
            link.transfer(msg.sender, link.balanceOf(address(this))),
            "Unable to transfer"
        );
    }
}
