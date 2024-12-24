// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DividendDistributor {
    address public admin;
    address[] public recipients;
    mapping(address => uint256) public dividends;
    uint256 public processedIndex; // Pamti dokle smo stigli sa obradom
    mapping(address => bool) public failedRecipients; // Beležimo neuspešne isplate

    constructor() {
        admin = msg.sender;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action.");
        _;
    }

    function AddRecipient(address recipient, uint256 amount) public onlyAdmin {
        require(recipient != address(0), "Invalid recipient address.");
        recipients.push(recipient);
        dividends[recipient] = amount;
    }

    function DistributeDividends(uint256 batchSize) public onlyAdmin {
    require(address(this).balance > 0, "No funds to distribute.");

    uint256 end = processedIndex + batchSize;
    if (end > recipients.length) {
        end = recipients.length;
    }

    for (uint256 i = processedIndex; i < end; i++) {
        address recipient = recipients[i];
        uint256 amount = dividends[recipient];

        if (amount > 0) {
            (bool success, ) = payable(recipient).call{value: amount}("");
            if (success) {
                dividends[recipient] = 0;
                failedRecipients[recipient] = false; // Resetujemo status neuspeha
            } else {
                failedRecipients[recipient] = true; // Beležimo neuspeh
            }
        }
    }

        processedIndex = end;
    }

    function RetryFailedPayments(uint256 batchSize) public onlyAdmin {
    uint256 count = 0;

    for (uint256 i = 0; i < recipients.length && count < batchSize; i++) {
        address recipient = recipients[i];

        if (failedRecipients[recipient]) {
            uint256 amount = dividends[recipient];

            if (amount > 0) {
                (bool success, ) = payable(recipient).call{value: amount}("");
                if (success) {
                    dividends[recipient] = 0;
                    failedRecipients[recipient] = false;
                }
            }
                count++;
            }
        }
    }

    function ResetProcessedIndex() public onlyAdmin {
        processedIndex = 0; // Resetuje obradu, ako je potrebno
    }

    function DepositFunds() public payable onlyAdmin {}

    function GetRecipients() public view returns (address[] memory) {
        return recipients;
    }
}
