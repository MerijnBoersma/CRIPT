// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract CarbonCreditToken is ERC20 {
    // Structure to store information about each carbon credit
    struct CarbonCredit {
        string validationBody;         // Body that validated the carbon credit (e.g., VCS, GoldStandard)
        string projectLocation;        // Location of the project associated with the carbon credit
        uint256 carbonCaptured;        // Amount of carbon captured/offset by the project
        string creditType;             // Type of carbon credit (e.g., renewable energy, reforestation)
        string projectName;            // Name of the project associated with the carbon credit
        string projectDescription;     // Description of the project
        uint256 validationDate;        // Date when the carbon credit was validated
        string issuer;                 // Entity that issued the carbon credit
    }

    // Mapping to store carbon credits by their unique ID
    mapping(uint256 => CarbonCredit) public carbonCredits;
    // Counter to keep track of the number of carbon credits issued
    uint256 public creditCounter;
    // Address of the contract administrator
    address public admin;

    // Constructor to initialize the token name and symbol, and set the admin address
    constructor() ERC20("CarbonCreditToken", "CCT") {
        admin = msg.sender;
    }

    // Modifier to restrict functions to the admin only
    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

    // Function to mint new carbon credit tokens
    function mint(
        address to,
        uint256 amount,
        string memory validationBody,
        string memory projectLocation,
        uint256 carbonCaptured,
        string memory creditType,
        string memory projectName,
        string memory projectDescription,
        uint256 validationDate,
        string memory issuer
    ) external onlyAdmin {
        // Ensure the amount of carbon captured is greater than 0
        require(carbonCaptured > 0, "Carbon captured must be greater than 0");
        // Ensure the amount of tokens to mint is greater than 0
        require(amount > 0, "Amount must be greater than 0");
        // Ensure the validation body is either VCS or GoldStandard
        require(
            keccak256(abi.encodePacked(validationBody)) == keccak256(abi.encodePacked("VCS")) || 
            keccak256(abi.encodePacked(validationBody)) == keccak256(abi.encodePacked("GoldStandard")), 
            "Invalid validation body"
        );

        // Store the new carbon credit details in the mapping
        carbonCredits[creditCounter] = CarbonCredit({
            validationBody: validationBody,
            projectLocation: projectLocation,
            carbonCaptured: carbonCaptured,
            creditType: creditType,
            projectName: projectName,
            projectDescription: projectDescription,
            validationDate: validationDate,
            issuer: issuer
        });

        // Mint the specified amount of tokens to the given address
        _mint(to, amount);
        // Increment the credit counter
        creditCounter++;
    }

    // Function to retrieve the details of a specific carbon credit by its ID
    function getCarbonCreditDetails(uint256 creditId) 
        external 
        view 
        returns (CarbonCredit memory) 
    {
        return carbonCredits[creditId];
    }

    // Function to burn (destroy) a specified amount of tokens from the caller's balance
    function burn(uint256 amount) external {
        _burn(msg.sender, amount);
    }

    // Function to transfer the admin role to a new address
    function transferAdminRole(address newAdmin) external onlyAdmin {
        require(newAdmin != address(0), "New admin address cannot be zero");
        admin = newAdmin;
    }
}
