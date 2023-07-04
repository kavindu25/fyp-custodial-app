// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

import "./CustodialServiceContract.sol";

contract CustodialServiceContractFactory {
    address[] public custodialServices;

    struct Organisation {
        bool isActive;
        string name;
        uint256 balance;
    }

    address public owner;

    mapping(address => Organisation) private organisations;

    constructor() {
        owner = msg.sender;
    }

    //modifiers
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this operation");
        _;
    }
    modifier onlyActiveUser(address user) {
        require(organisations[user].isActive, "Organisation must be active to perform this operation");
        _;
    }

    // create new instance of CustodialServiceContract
    function createCustodialService(address marketplaceOwner) public {
        CustodialServiceContract custodialService = new CustodialServiceContract(marketplaceOwner);
        custodialServices.push(address(custodialService));
    }

    // return all deployed CustodialServiceContract instances
    function getDeployedCustodialServiceContracts() public view returns (address[] memory) {
        return custodialServices;
    }

}