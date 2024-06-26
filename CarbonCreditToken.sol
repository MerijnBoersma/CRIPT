// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract CarbonCreditToken is ERC20 {
    struct CarbonCredit {
        string validationBody;  
        string projectLocation; 
        uint256 carbonCaptured; 
        string creditType;      
        string projectName;     
        string projectDescription;
        uint256 validationDate;
        string issuer;          
    }

    mapping(uint256 => CarbonCredit) public carbonCredits;
    uint256 public creditCounter;
    address public admin;

    constructor() ERC20("CarbonCreditToken", "CCT") {
        admin = msg.sender;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

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
        require(carbonCaptured > 0, "Carbon captured must be greater than 0");
        require(amount > 0, "Amount must be greater than 0");
        require(keccak256(abi.encodePacked(validationBody)) == keccak256(abi.encodePacked("VCS")) || 
                keccak256(abi.encodePacked(validationBody)) == keccak256(abi.encodePacked("GoldStandard")), 
                "Invalid validation body");

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

        _mint(to, amount);
        creditCounter++;
    }

    function getCarbonCreditDetails(uint256 creditId) 
        external 
        view 
        returns (CarbonCredit memory) 
    {
        return carbonCredits[creditId];
    }

    function burn(uint256 amount) external {
        _burn(msg.sender, amount);
    }

    function transferAdminRole(address newAdmin) external onlyAdmin {
        require(newAdmin != address(0), "New admin address cannot be zero");
        admin = newAdmin;
    }
}