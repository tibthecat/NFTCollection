// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Script.sol";
import "../src/SynthCats.sol"; // adjust path to your contract

contract Deploy is Script {
    function setUp() public {}

    function run() public {
        vm.startBroadcast();


        string memory _name = "SynthCats";
        string memory _symbol = "SCAT";
        string memory _baseTokenURI = "ipfs://bafybeibpug2ub23ocp5i3rgo2mkqet2at5u53axptb537ppqmtcyq2opge/";
        uint _mintStartTimestamp = block.timestamp;


        SynthCats nft = new SynthCats(_name,_symbol,_baseTokenURI,_mintStartTimestamp); 
        vm.stopBroadcast();
    }
}