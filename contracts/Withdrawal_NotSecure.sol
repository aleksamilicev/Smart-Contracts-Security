// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract Withdrawal {

    function CheckBallance() public view returns(uint256) {
        return address(this).balance;   // prikazuje saldo ugovora u Wei
    }

    function Deposit() public payable {
        require(msg.value > 0, "Number must be greater then 0!");
    }

    function Withdraw(uint256 money) public{
        require(CheckBallance() >= money, "Not enough funds in the contract!");
        payable (msg.sender).transfer(money);
    }
}