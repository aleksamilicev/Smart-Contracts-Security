// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract Withdrawal{

    function CheckBallance() public view returns(uint256) {
        return address(this).balance;   // prikazuje saldo ugovora u Wei
        // address(this), vraca adresu trenutnog korisnika
        // .balance vraca vrednost u Wei
        // i ovo je READ-ONLY
    }

    function Deposit() public payable {
        // BITNO - vrednosti unosis preko VALUE POLJA, a onda sa njima rukujes preko funkcija u contract-u
        // funkcija je payable i omogucava primanje ETH
        // msg znaci trenutna poruka koju je korisnik uneo
        // msg.value je u Wei, 1 ETH = 10^18 Wei, znaci msg.value = 1000000...
        // require je funkcija koja sluzi kao provera
        require(msg.value > 0, "Number must be greater then 0!");
    }

    function Withdraw(uint256 money) public{
        require(CheckBallance() >= money, "Not enough funds in the contract!");

        // Slanje Wei korisniku koji je pozvao funkciju
        payable (msg.sender).transfer(money);
        // msg.sender predstavlja adresu korisnika koji poziva funkciju
    }
}