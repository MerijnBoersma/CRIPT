// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./CarbonCreditToken.sol";

contract CarbonTrading {
    struct Trade {
        address seller;
        uint256 amount;
        uint256 price;
    }

    CarbonCreditToken public carbonCreditToken;
    mapping(uint256 => Trade) public trades;
    uint256 public tradeCounter;

    constructor(address tokenAddress) {
        carbonCreditToken = CarbonCreditToken(tokenAddress);
    }

    function listForSale(uint256 amount, uint256 price) external {
        require(carbonCreditToken.balanceOf(msg.sender) >= amount, "Insufficient balance");

        trades[tradeCounter] = Trade({
            seller: msg.sender,
            amount: amount,
            price: price
        });

        tradeCounter++;
    }

    function buy(uint256 tradeId) external payable {
        Trade memory trade = trades[tradeId];
        require(msg.value == trade.price, "Incorrect price");

        carbonCreditToken.transferFrom(trade.seller, msg.sender, trade.amount);
        payable(trade.seller).transfer(msg.value);

        delete trades[tradeId];
    }
}