// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Vault} from "../src/Vault.sol";
import {MockUSDC} from "../src/MockUSDC.sol";

contract VaultTest is Test {
    Vault public vault;
    MockUSDC public usdc;

    address public alice = makeAddr("Alice");
    address public bob = makeAddr("Bob");
    address public carl = makeAddr("Carl");
    address public owner;

    function setUp() public {
        usdc = new MockUSDC();
        vault = new Vault(address(usdc));

        usdc.mint(alice, 100e18);
        usdc.mint(bob, 50e18);
        usdc.mint(carl, 50e18);

        owner = address(this);
        usdc.mint(owner, 150e18);
    }

    function test_deposit() public {
       vm.startPrank(alice);
       usdc.approve(address(vault),100e18);
       vault.deposit(100e18);
       vm.stopPrank();

       assertEq(usdc.balanceOf(address(vault)),100e18);
       assertEq(vault.balanceOf(alice),100e18);
       console.log(vault.balanceOf(alice));

       vm.startPrank(bob);
       usdc.approve(address(vault),50e18);
       vault.deposit(50e18);
       vm.stopPrank();

      // totalAssets = 150e18
       assertEq(usdc.balanceOf(address(vault)),150e18);
       // Bob balance = 50e18
       assertEq(vault.balanceOf(bob),50e18);

       // owner mendistribusikan keuntungan
       vm.startPrank(owner);
       usdc.approve(address(vault),150e18);
       vault.distributeYield(150e18);
       vm.stopPrank();

       assertEq(usdc.balanceOf(address(vault)),300e18);

       // withdraw test
       vm.prank(alice);
       vault.withdraw(100e18);  

       // USDC di vault
       console.log('USDC balance of vault',usdc.balanceOf(address(vault)));
       assertEq(usdc.balanceOf(address(vault)),100e18);
       assertEq(vault.balanceOf(alice),0);
       assertEq(usdc.balanceOf(alice),200e18);
    }

}
