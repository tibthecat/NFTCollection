// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../src/SynthCats.sol";

contract SynthCatsTest is Test {
    SynthCats synthCats;

    uint256 constant MINT_PRICE = 0.05 ether;
    uint256 constant MINT_START = 1_700_000_000; // arbitrary future timestamp
    address user = address(1);
    address owner = address(2);
    function setUp() public {
        vm.deal(user, 10 ether);        // give user 10 ETH
        // Deploy contract with mint start in the future
        vm.prank(owner);
        synthCats = new SynthCats("SynthCats", "SYN", "ipfs://baseURI/", MINT_START);

        // Warp to a time before mint start
        vm.warp(MINT_START - 1000);
    }

    function testMintBeforeStartReverts() public {
        vm.prank(user);
        vm.expectRevert("Minting not started yet");
        synthCats.mint{value: MINT_PRICE}(1);
    }

    function testMintSuccess() public {
        // Warp time to mint start
        vm.warp(MINT_START + 10);

        vm.prank(user);
        // Mint one token with correct ETH
        synthCats.mint{value: MINT_PRICE}(1);

        assertEq(synthCats.balanceOf(user), 1);
        assertEq(synthCats.currentTokenId(), 1);
    }

    function testMintInsufficientETHReverts() public {
        vm.warp(MINT_START + 10);
        vm.prank(user);
        vm.expectRevert("Insufficient ETH sent");
        synthCats.mint{value: MINT_PRICE - 1}(1);
    }

    function testMintLimitPerAddress() public {
        vm.warp(MINT_START + 10);

        uint256 maxMint = 5;

        // Mint max allowed
        vm.prank(user);
        synthCats.mint{value: MINT_PRICE * maxMint}(maxMint);

        // Try minting one more -> revert
        vm.prank(user);
        vm.expectRevert("Mint limit exceeded");
        synthCats.mint{value: MINT_PRICE}(1);
    }

    function testWithdraw() public {
        vm.warp(MINT_START + 10);

        // Mint tokens to have contract balance
        vm.prank(user);
        synthCats.mint{value: MINT_PRICE * 2}(2);
       

        uint256 ownerBalanceBefore = address(owner).balance;
        vm.prank(owner);
        synthCats.withdraw();
        uint256 ownerBalanceAfter = address(owner).balance;

        // Check that contract balance moved to owner
        assertGt(ownerBalanceAfter, ownerBalanceBefore);
        assertEq(address(synthCats).balance, 0);
    }
}
