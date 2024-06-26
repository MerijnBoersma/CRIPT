// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./CarbonCreditToken.sol";

contract CarbonTrading {
    // Structure to store information about each trade
    struct Trade {
        address seller;   // Address of the seller
        uint256 amount;   // Amount of tokens to be sold
        uint256 price;    // Price of the tokens in wei
    }

    // Reference to the CarbonCreditToken contract
    CarbonCreditToken public carbonCreditToken;
    // Mapping to store trades by their unique ID
    mapping(uint256 => Trade) public trades;
    // Counter to keep track of the number of trades
    uint256 public tradeCounter;

    // Constructor to set the address of the CarbonCreditToken contract
    constructor(address tokenAddress) {
        carbonCreditToken = CarbonCreditToken(tokenAddress);
    }

    // Function to list tokens for sale
    function listForSale(uint256 amount, uint256 price) external {
        // Ensure the seller has enough tokens to list for sale
        require(carbonCreditToken.balanceOf(msg.sender) >= amount, "Insufficient balance");

        // Store the trade details in the mapping
        trades[tradeCounter] = Trade({
            seller: msg.sender,
            amount: amount,
            price: price
        });

        // Increment the trade counter
        tradeCounter++;
    }

    // Function to buy listed tokens
    function buy(uint256 tradeId) external payable {
        // Retrieve the trade details from the mapping
        Trade memory trade = trades[tradeId];
        // Ensure the buyer sends the correct amount of Ether
        require(msg.value == trade.price, "Incorrect price");

        // Transfer the tokens from the seller to the buyer
        carbonCreditToken.transferFrom(trade.seller, msg.sender, trade.amount);
        // Transfer the Ether to the seller
        payable(trade.seller).transfer(msg.value);

        // Remove the trade from the mapping
        delete trades[tradeId];
    }
}
