// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract CustodialServiceContract {
    
    struct User {
        bool isActive;
        uint256 balance;
        address whitelistAddress;
    }

    address public owner;
    uint256 public commissionFee;
    uint256 public marketplaceBalance;
    //uint256 public excessBalance;
    mapping(address => User) private users;

    //constructor
    constructor(address marketplaceOwner) {
        owner = marketplaceOwner;
        commissionFee = 0.2 ether;
    }

    //events
    event AddUser(address newUser, address newWhitelistAddress);
    event DeactivateUser(address user);
    event TopUpETH(uint256 depositedAmount, address sender);
    event TransferETH(address sender, address receiver,uint256 amount);
    event WithdrawETH(uint256 amount, address receiver);
    event WithDrawETHByOwner(uint256 amount, address receiver);

    //modifiers
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this operation");
        _;
    }
    modifier onlyActiveUser(address user) {
        require(users[user].isActive, "User must be active to perform this operation");
        _;
    }

    //functions
    function addUser(address newUser, address whitelistAddress) public onlyOwner {
        require(newUser != address(0), "Invalid address");
        require(!users[newUser].isActive, "User already exists");
        
        users[newUser] = User({
            isActive: true,
            balance: 0,
            whitelistAddress: whitelistAddress //a user has a whitelist address
        });

        emit AddUser(newUser, whitelistAddress);
    }

    function deactivateUser(address user) public onlyOwner {
        require(users[user].isActive, "User is already deactivated");
        users[user].isActive = false;
        // send the users leftover balance to whitelistaddress and remove the balance from the marketplace balance
        marketplaceBalance -= users[user].balance;
        address withdrawAddress = users[user].whitelistAddress;
        payable(withdrawAddress).transfer(users[user].balance);

        emit DeactivateUser(user);
    }

    function transferETH(address sender, address receiver, uint256 amount) public payable onlyOwner onlyActiveUser(sender) {
        require(users[receiver].isActive, "Receiver is an inactive user");
        require(users[sender].balance >= amount, "Insufficient balance");
        require(amount < marketplaceBalance, "Transfer amount limit exceeded");
        
        users[sender].balance -= amount;
        users[receiver].balance += amount;

        emit TransferETH(sender, receiver, amount);
    }

    function topUpETH(uint256 amount, address user) public payable onlyActiveUser(user) {
        require(msg.value == amount, "Transferred amount does not match the specified amount");
        require(amount > commissionFee, "Top up amount is less than the commissin fee");
        uint256 depositableAmount = amount - commissionFee;
        users[user].balance += depositableAmount;
        marketplaceBalance += depositableAmount;
        emit TopUpETH(depositableAmount, msg.sender);
    }

    function withdrawETH(uint256 amount, address user, address payable receiver) public payable onlyOwner onlyActiveUser(user) {
        //require(users[user].whitelistAddress == msg.sender, "User has no permission to withdraw");
        //require(users[user].balance >= amount, "Insufficient balance");
        require(users[user].whitelistAddress == receiver);

        receiver.transfer(amount);
        users[user].balance -= amount;
        marketplaceBalance -= amount;
        
        emit WithdrawETH(amount, receiver); 
    }

    // can be executed by the contract owner
    // to do: put who can execute for every function 
    
    function withdrawETHByOwner(uint256 amount, address payable receiver) public payable onlyOwner() {
        //checks if the withdraw amount is less or equal than the excess amount of the contract
        require((address(this).balance - marketplaceBalance) >= amount );
        receiver.transfer(amount);

        emit WithDrawETHByOwner(amount, receiver);
    }

    function getUserInfo(address user) public view returns(User memory) {
        return users[user];
    }

    function getUserBalance(address user) public view returns (uint256) {
        return users[user].balance;
    }

}

// to do list:
    // seperate function for owner to withdraw with payable,onlyowner
    // contract funds > marketplcebalance, then withdraw fail
    // if there is an excessive amount other than the users balances
    // fixed cut for topup function

//withdrawETH(users[user].balance, user, payable(withdrawAddress));
//receiver.transfer(address(this).balance);
//payable(user).transfer(address(this).amount);

//withdrawETH func:
// onlyowner or anyone ?

//