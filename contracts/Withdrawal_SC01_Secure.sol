// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract Withdrawal is ReentrancyGuard {
    // mapping je HashMap-a, address nam je kljuc, a uint256 nam je vrednost
    // balances nam je naziv ove HashMap-e
    // Private znaci da je ova mapa dostupna samo funkcijama u ovom ugovoru
    mapping(address => uint256) private balances;

    // Funkcija za proveru balansa korisnika
    function CheckBalance() public view returns (uint256) {
        return balances[msg.sender];
    }

    // Funkcija za uplatu ETH-a na ugovor
    function Deposit() public payable {
        require(msg.value > 0, "You must deposit more than 0 ETH.");
        balances[msg.sender] += msg.value; // Ažurira stanje korisnika pre
        // pre poziva call funkcije time se dodatno štitimo od reentrancy napada
    }

    // Funkcija za povlačenje ETH-a uz zaštitu od reentrancy napada
    function Withdraw(uint256 amount) public nonReentrant {
        require(balances[msg.sender] >= amount, "Insufficient balance.");
        
        // Ažuriraj stanje pre transfera da bi se izbegao reentrancy napad
        balances[msg.sender] -= amount;

        // Koristi `call` za transfer sredstava
        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "Transfer failed.");
        // ("") označava dodatni parametar
        // .call vraća 2 parametra, 1. bool success(da li je transfer bio uspešan
        // ili ne), 2. data(povratni podaci, ne koriste se u ovom slučaju)
    }
}
