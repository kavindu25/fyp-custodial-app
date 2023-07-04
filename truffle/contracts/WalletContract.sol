// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract WalletContract {
    mapping(address => uint256) public balances;
    address payable wallet;

    constructor(address payable _wallet) {
        wallet = _wallet;
    }
    

    function buyToken() public payable {
        balances[msg.sender] += 1;
        wallet.transfer(msg.value);

    }
}