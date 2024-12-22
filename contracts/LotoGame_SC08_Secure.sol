// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract LotoGame {
    address[] private players; // Lista igrača
    mapping(address => bool) private hasEntered; // Mapa za praćenje unosa

    function EnterLottery() public payable {
        require(msg.value > 0, "In order to play, the value must be greater than zero.");
        require(!hasEntered[msg.sender], "You can only enter once per game."); // Provera da li je već učestvovao
        
        hasEntered[msg.sender] = true; // Obeležavamo da je igrač uneo uplatu
        players.push(msg.sender); // Dodajemo igrača u listu
    }

    function PickWinner() public {
        require(players.length > 0, "No players have entered the lottery.");
        // Generisanje pseudonasumičnog broja koristeći block.prevrandao
        uint256 winnerIndex = uint256(keccak256(abi.encodePacked(block.prevrandao, block.timestamp, players.length))) % players.length;
        address winner = players[winnerIndex];
        payable(winner).transfer(address(this).balance);
    }

    function ResetLotteryWithRefund() public {
        require(players.length > 0, "Lottery has already been reset.");
        
        // Resetujemo vrednosti u mapi hasEntered
        for (uint256 i = 0; i < players.length; i++) {
            hasEntered[players[i]] = false; // Postavljamo vrednost na false
        }
        delete players; // Resetujemo listu igrača
    }

    function GetPlayers() public view returns (address[] memory) {
        return players;
    }

    function CheckBalance() public view returns (uint256) {
        return address(this).balance; // Prikazuje saldo ugovora
    }
}
