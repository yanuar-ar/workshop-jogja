// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Counter} from "../src/Counter.sol";

contract CounterTest is Test {
    Counter public counter;

    function setUp() public {
        counter = new Counter(100);
        counter.setNumber(0);
    }

    function test_Increment() public {
        counter.increment();
        assertEq(counter.number(), 1);
    }

    function testFuzz_SetNumber(uint256 x) public {
        counter.setNumber(x);
        assertEq(counter.number(), x);
    }

    function test_TotalSupply() public {
        console.log(counter.totalSupply());
        assertEq(counter.totalSupply(), 1000);
    }

    function test_SetPrice() public {
        console.log(counter.owner());
        counter.setPrice(100);
        assertEq(counter.price(), 100);
    }

    function test_Add() public {
        assertEq(counter.add(1, 2), 3);
    }

    function test_SetOwner() public {
        address alice = address(1);
        counter.setOwner(alice);
        assertEq(counter.owner(), alice);

        // ubah price dgn owner yang baru
        vm.expectRevert("Only owner can set price");
        counter.setPrice(200);

        vm.prank(alice);
        counter.setPrice(300);
        assertEq(counter.price(), 300);
    }
}
