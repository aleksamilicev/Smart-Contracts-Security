// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract Withdrawal is ReentrancyGuard {
    mapping(address => uint256) private balances;

    function CheckBalance() public view returns (uint256) {
        return balances[msg.sender];
    }

    function Deposit() public payable {
        require(msg.value > 0, "You must deposit more than 0 ETH.");
        balances[msg.sender] += msg.value;
    }

    function Withdraw(uint256 amount) public nonReentrant {
        require(balances[msg.sender] >= amount, "Insufficient balance.");
        
        balances[msg.sender] -= amount;

        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "Transfer failed.");
    }
}
