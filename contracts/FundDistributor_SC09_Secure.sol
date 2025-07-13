// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract FundDistributor_BatchRefund {
    mapping(address => uint256) public balances; // Čuva uloge korisnika
    address public admin; // Admin ugovora
    address[] public users; // Lista korisnika
    uint256 public currentIndex; // Indeks trenutnog korisnika za refundaciju

    constructor() {
        admin = msg.sender; // Admin postaje kreator ugovora
    }

    // Funkcija za uplatu sredstava
    function Deposit() public payable {
        require(msg.value > 0, "Deposit must be greater than zero.");

        if (balances[msg.sender] == 0) {
            users.push(msg.sender); // Dodaje korisnika samo ako nije već na listi
        }

        balances[msg.sender] += msg.value; // Ažurira saldo korisnika
    }

    // Admin započinje proces refundiranja
    function RefundBatch(uint256 batchSize) public {
        require(msg.sender == admin, "Only admin can refund.");
        require(batchSize > 0, "Batch size must be greater than zero.");

        uint256 processed = 0;
        while (currentIndex < users.length && processed < batchSize) {
            address user = users[currentIndex];
            uint256 amount = balances[user];
            if (amount > 0) {
                balances[user] = 0; // Označavamo da je korisnik refundiran, tj da su mu vraćena sredstva
                (bool success, ) = user.call{value: amount}("");
                    if (success) {
                        balances[user] = 0;
                    } // Vraća sredstva korisniku
            }
            currentIndex++;
            processed++;
        }
    }

    // Proverava da li je refundiranje završeno
    function IsRefundComplete() public view returns (bool) {
        return currentIndex >= users.length;
    }

    // Admin resetuje ugovor posle refundiranja
    function ResetContract() public {
        require(msg.sender == admin, "Only admin can reset the contract.");
        require(IsRefundComplete(), "Refund process not complete.");
        delete users; // Resetuje listu korisnika
        currentIndex = 0; // Resetuje indeks
    }

    // Proverava stanje ugovora
    function CheckBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
