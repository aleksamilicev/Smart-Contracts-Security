// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0; // Verzija Solidity kompajlera

// Definicija smart contract-a
contract MojPrviKontrakt {

    // Promenljive stanja (state variables)
    string public ime;    // Javno dostupna string promenljiva
    uint256 public broj;  // Javno dostupna celobrojna promenljiva (unsigned integer)

    // Konstruktor - izvršava se jednom prilikom deploy-a
    constructor(string memory _ime, uint256 _broj) {
        ime = _ime;
        broj = _broj;
    }

    // Funkcija za promenu vrednosti promenljive
    function postaviBroj(uint256 _noviBroj) public {
        broj = _noviBroj;
    }

    // Funkcija za dohvat vrednosti promenljive
    function preuzmiBroj() public view returns (uint256) {
        return broj;
    }
}
