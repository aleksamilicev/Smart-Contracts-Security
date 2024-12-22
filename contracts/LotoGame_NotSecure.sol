// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract LotoGame {
    address[] private players; // Lista igrača
    mapping(address => bool) private hasEntered; // Mapa za praćenje unosa
    mapping(address => uint256) private deposits; // Mapa za praćenje uplaćenih sredstava
    // deposits da bi osigurali ukoliko je doslo do nekog foul play-a da se korisnicima vrati ulog prilikom reseta

    function EnterLottery() public payable {
        require(msg.value > 0, "In order to play, the value must be greater than zero.");
        require(!hasEntered[msg.sender], "You can only enter once per game."); // Provera da li je već učestvovao
        
        hasEntered[msg.sender] = true; // Obeležavamo da je igrač uneo uplatu
        deposits[msg.sender] = msg.value; // Beležimo iznos koji je igrač uplatio
        players.push(msg.sender); // Dodajemo igrača u listu
    }

    function PickWinner() public {
        require(players.length > 0, "No players have entered the lottery.");
        uint256 winnerIndex = uint256(block.timestamp) % players.length;
        address winner = players[winnerIndex];
        payable(winner).transfer(address(this).balance);
    }

    function ResetLotteryWithRefund() public {
        require(players.length > 0, "Lottery has already been reset.");
        
        // Refundiramo sva sredstva korisnicima
        for (uint256 i = 0; i < players.length; i++) {
            address player = players[i];
            uint256 amount = deposits[player];
            
            if (amount > 0) {
                deposits[player] = 0; // Resetujemo deponovani iznos
                hasEntered[player] = false; // Resetujemo ulazak
                payable(player).transfer(amount); // Refundiramo ETH
            }
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
