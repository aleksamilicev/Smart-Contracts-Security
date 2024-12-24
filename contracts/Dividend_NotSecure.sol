// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Logika ugovora:
// 1. Admin uplacuje svotu novca sa kojom ce kasnije da rukuje
// 2. Admin dodaje adresu korisnika i kolicinu dividende koja treba da mu bude isplacena
// 3. Admin salje korisnicima dividende
// **Ranjivost: ukoliko jednom od korisnika padne ugovoro(javi se greska), transakcija ce
// biti obustavljena i ni jednom korisniku nece biti isplacen novac
// Imamo 2 ranjivosti, DoS i Gas Limit.
// DoS za dodavanje novih korisnika, jer ukoliko ima previše korisnika to može izazvati Gas Limit ranjivost
// Ovo bi rešili sa batch processing korisnika, ne bi sve korisnike procesirali odjednom i na ovaj način
// smo sprečili gas overflow
contract DividendDistributor {
    address public admin;
    address[] public recipients;
    mapping(address => uint256) public dividends;

    constructor() {
        admin = msg.sender;
    }

    // Modifier omogućava da više funkcija u ugovoru koristi istu logiku bez potrebe da se ponavlja kod
    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action.");
        _; // Ovo označava mesto gde će biti ostatak koda
    }

    function AddRecipient(address recipient, uint256 amount) public onlyAdmin {
        require(recipient != address(0), "Invalid recipient address.");
        recipients.push(recipient);
        dividends[recipient] = amount;
    }

    function DistributeDividends() public onlyAdmin {
        require(address(this).balance > 0, "No funds to distribute.");

        for (uint256 i = 0; i < recipients.length; i++) {
            address recipient = recipients[i];
            uint256 amount = dividends[recipient];

            if (amount > 0) {
                // Isplaćuje dividendu
                payable(recipient).transfer(amount);
                dividends[recipient] = 0; // Resetuje iznos nakon isplate
            }
        }
    }

    function DepositFunds() public payable onlyAdmin {}

    function GetRecipients() public view returns (address[] memory) {
        return recipients;
    }
}
