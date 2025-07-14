// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

contract Auction {
    address public highestBidder;
    uint256 public highestBid;
    uint256 public biddingEnd;
    uint256 public revealEnd;
    bool public auctionEnded;
    address payable public seller;

    mapping(address => bytes32) public bidCommits;
    mapping(address => uint256) public revealedBids;
    address[] public bidders;

    constructor(uint256 biddingTimeInBlocks, uint256 revealTimeInBlocks) {
        biddingEnd = block.number + biddingTimeInBlocks;
        revealEnd = biddingEnd + revealTimeInBlocks;
        seller = payable(msg.sender);
    }

    // ✅ Nova helper funkcija — koristi se za izračunavanje hasha on-chain
    function GenerateBidHash(uint256 amount, string memory secret) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(amount, secret));
    }

    // Commit faza — slanje hash vrednosti bida
    function CommitBid(bytes32 bidHash) external {
        require(block.number < biddingEnd, "Commit phase ended.");
        require(bidCommits[msg.sender] == 0x0, "Already committed.");
        bidCommits[msg.sender] = bidHash;
        bidders.push(msg.sender);
    }

    // Reveal faza — otkrivanje bida i slanje ETH
    function RevealBid(uint256 amount, string memory secret) external payable {
        require(block.number >= biddingEnd && block.number < revealEnd, "Not in reveal phase.");
        require(bidCommits[msg.sender] != 0x0, "No commitment found.");
        require(msg.value == amount, "ETH sent must match bid.");
        require(keccak256(abi.encodePacked(amount, secret)) == bidCommits[msg.sender], "Hash mismatch.");

        revealedBids[msg.sender] = amount;

        if (amount > highestBid) {
            if (highestBidder != address(0)) {
                // Refund previous highest bidder
                payable(highestBidder).transfer(highestBid);
            }
            highestBidder = msg.sender;
            highestBid = amount;
        } else {
            // Refund non-winning bidder immediately
            payable(msg.sender).transfer(amount);
        }
    }

    function FinalizeAuction() external {
        require(block.number >= revealEnd, "Reveal phase not yet ended.");
        require(!auctionEnded, "Auction already finalized.");
        auctionEnded = true;
        // The highestBid remains in contract; can be claimed by seller or handled as desired
        if (highestBid > 0) {
            seller.transfer(highestBid); // seller dobija najvišu ponudu
        }
    }

    // (Optional) Check remaining time
    function TimeLeftCommit() external view returns (uint256) {
        return block.number >= biddingEnd ? 0 : biddingEnd - block.number;
    }

    function TimeLeftReveal() external view returns (uint256) {
        if (block.number < biddingEnd) return 0;
        return block.number >= revealEnd ? 0 : revealEnd - block.number;
    }
}
