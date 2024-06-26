// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./CarbonCreditToken.sol";

contract CarbonRetirement {
    CarbonCreditToken public carbonCreditToken;

    constructor(address tokenAddress) {
        carbonCreditToken = CarbonCreditToken(tokenAddress);
    }

    function retire(uint256 amount) external {
        require(carbonCreditToken.balanceOf(msg.sender) >= amount, "Insufficient balance");
        carbonCreditToken.burn(amount);
    }
}