// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract SynthCats is ERC721URIStorage, Ownable {
    uint256 public currentTokenId;
    string private baseTokenURI;

    uint256 public constant MINT_PRICE = 0.001 ether;
    uint256 public constant MAX_SUPPLY = 20;

    uint256 public mintStartTimestamp;

    mapping(address => uint256) public mintedPerAddress;
    uint256 public constant MAX_MINT_PER_ADDRESS = 5;

    constructor(string memory _name, string memory _symbol, string memory _baseTokenURI, uint256 _mintStartTimestamp)
        ERC721(_name, _symbol)
        Ownable(msg.sender) // Pass deployer as initial owner
    {
        baseTokenURI = _baseTokenURI;
        mintStartTimestamp = _mintStartTimestamp;
    }

    modifier mintActive() {
        require(block.timestamp >= mintStartTimestamp, "Minting not started yet");
        _;
    }

    function mint(uint256 quantity) external payable mintActive {
        require(quantity > 0, "Must mint at least one token");
        require(currentTokenId + quantity <= MAX_SUPPLY, "Max supply reached");
        require(mintedPerAddress[msg.sender] + quantity <= MAX_MINT_PER_ADDRESS, "Mint limit exceeded");
        require(msg.value >= MINT_PRICE * quantity, "Insufficient ETH sent");

        for (uint256 i = 0; i < quantity; i++) {
            currentTokenId++;
            mintedPerAddress[msg.sender]++;
            _safeMint(msg.sender, currentTokenId);
        }
    }

    // Owner can update the base URI if needed
    function setBaseURI(string memory _baseTokenURI) external onlyOwner {
        baseTokenURI = _baseTokenURI;
    }

    function _baseURI() internal view override returns (string memory) {
        return baseTokenURI;
    }

    // Withdraw function for owner to collect funds
    function withdraw() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }
}
