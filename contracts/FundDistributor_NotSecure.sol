// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract FundDistributor_NotSecure {
    mapping(address => uint256) public balances; // Čuva uloge korisnika
    address[] public contributors; // Niz svih korisnika
    address public admin; // Admin ugovora

    constructor() {
        admin = msg.sender; // Admin postaje kreator ugovora
    }

    // Funkcija za uplatu sredstava u zajednički fond
    function Deposit() public payable {
        require(msg.value > 0, "Deposit must be greater than zero.");

        if (balances[msg.sender] == 0) {
            contributors.push(msg.sender); // Dodaje korisnika u listu ako već nije na njoj
        }

        balances[msg.sender] += msg.value; // Ažurira saldo korisnika
    }

    // Admin pokreće refundiranje svih sredstava korisnicima
    // Ovo je ne bezbedno je što je niz veći to ćemo više gasa koristiti da ga iteriramo
    // Napadač može da eksploatiše tako što će puno puta da uplati novac i niz će biti 
    // previše dugačak, nećemo imati dovoljno gasa da vratimo korisnicima sredstva koja su uplatili
    function RefundAll() public {
        require(msg.sender == admin, "Only admin can refund.");
        require(contributors.length > 0, "No contributors to refund.");

        for (uint256 i = 0; i < contributors.length; i++) {
            address contributor = contributors[i];
            uint256 amount = balances[contributor];

            if (amount > 0) {
                payable(contributor).transfer(amount); // Prebacuje sredstva nazad korisniku
                balances[contributor] = 0; // Resetuje saldo korisnika
            }
        }

        delete contributors; // Resetuje listu korisnika
    }

    // Provera stanja ugovora
    function CheckBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
