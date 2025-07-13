// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract Auction {
    address public highestBidder; // Adresa trenutnog pobednika
    uint256 public highestBid; // Najveća ponuda
    uint256 public auctionEndTime; // Vreme završetka aukcije
    bool public auctionEnded;
    mapping(address => uint256) public bids; // Mapa preko koje pratimo ulog
    address[] public bidders; // Lista svih učesnika

    constructor(uint256 biddingTimeInSeconds) {
        uint256 randomSeed = uint256(keccak256(abi.encodePacked(blockhash(block.number - 1), block.number, block.prevrandao)));
        auctionEndTime = (randomSeed % 200) + block.number + biddingTimeInSeconds;
        auctionEnded = false;
    }

    function PlaceBid() public payable {
        require(block.number <= auctionEndTime, "Auction has ended.");
        require(msg.value > highestBid, "There already is a higher bid.");

        // Vraćamo prethodni bid, ako postoji
        if (highestBid != 0) {
            bids[highestBidder] += highestBid;
        }

        highestBidder = msg.sender;
        highestBid = msg.value;

        // Dodajemo novog bidder-a u listu
        bidders.push(msg.sender);
    }

    function FinalizeAuction() public {
        require(block.number >= auctionEndTime, "Auction is still ongoing.");
        require(!auctionEnded, "Auction already finalized.");

        auctionEnded = true;

        // Prebacivanje novca na najvišeg bidder-a
        payable(highestBidder).transfer(highestBid);

        // Vraćanje svih ostalih uloga
        for (uint256 i = 0; i < bidders.length; i++) {
            address bidder = bidders[i];
            uint256 refund = bids[bidder];
            if (refund > 0) {
                payable(bidder).transfer(refund);
                bids[bidder] = 0; // Resetujemo vrednost
            }
        }
        
        // Resetujemo listu ponuđača nakon završetka aukcije
        delete bidders;
    }

    function GetTimeLeft() public view returns (uint256) {
        if (block.number >= auctionEndTime) {
            return 0;
        }
        return auctionEndTime - block.number;
    }


}
