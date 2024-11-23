// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Token} from "../src/Token.sol";

contract TokenTest is Test {
    Token public token;

    function setUp() public {
        token = new Token();
    }

    function test_TotalSupply() public {
        console.log(token.balanceOf(address(this)));
        assertEq(token.totalSupply(), 1000);
    }

    function test_Mint() public {
        address alice = address(1);
        address bob = address(2);
        token.mint(alice, 100);
        token.mint(bob, 200);

        uint256 aliceBalance = token.balanceOf(alice);
        uint256 bobBalance = token.balanceOf(bob);

        assertEq(aliceBalance, 100);
        assertEq(bobBalance, 200);

        vm.expectRevert("Max supply exceeded");
        token.mint(alice,100e40);
    }

    function testFuzz_Mint(address user, uint256 amount) public {
        vm.assume(user != address(0));
        vm.assume(amount > 0);
        amount = bound(amount, 1, 100_000_000_000_000_000_000e18);

        token.mint(user, amount);
        assertEq(token.balanceOf(user), amount);
    }
    
}
