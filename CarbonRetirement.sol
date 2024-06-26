// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./CarbonCreditToken.sol";

contract CarbonRetirement {
    // Reference to the CarbonCreditToken contract
    CarbonCreditToken public carbonCreditToken;

    // Constructor to set the address of the CarbonCreditToken contract
    constructor(address tokenAddress) {
        carbonCreditToken = CarbonCreditToken(tokenAddress);
    }

    // Function to retire (burn) a specified amount of carbon credit tokens
    function retire(uint256 amount) external {
        // Ensure the caller has enough tokens to retire
        require(carbonCreditToken.balanceOf(msg.sender) >= amount, "Insufficient balance");
        // Call the burn function on the CarbonCreditToken contract to burn the specified amount
        carbonCreditToken.burn(amount);
    }
}
