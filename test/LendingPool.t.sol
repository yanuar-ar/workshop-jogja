// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {IERC20} from "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import {LendingPool} from "../src/LendingPool.sol";

contract LendingPoolTest is Test {
    address public usdc = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    address public wbtc = 0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599;

    LendingPool public lendingPool;

    address alice = makeAddr("alice");
    address bob = makeAddr("bob");

    function setUp() public {
        vm.createSelectFork("https://eth-mainnet.g.alchemy.com/v2/Ea4M-V84UObD22z2nNlwDD9qP8eqZuSI", 21197642);

        lendingPool = new LendingPool();

        deal(usdc, alice, 1000e6);
    }

    function test_supply() public {
        // deposit
        vm.startPrank(alice);
        IERC20(usdc).approve(address(lendingPool), 1000e6);
        lendingPool.supply(1000e6);
        vm.stopPrank();

        vm.startPrank(bob);
        lendingPool.borrow(100e6);
        vm.stopPrank();

        console.log("totalSupplyAssets =", lendingPool.totalSupplyAssets());
        console.log("Alice userSupplyShares =", lendingPool.userSupplyShares(alice));

        vm.warp(block.timestamp + 1 days);

        lendingPool.accrueInterest();

        console.log("totalSupplyAssets setelah 1 hari =", lendingPool.totalSupplyAssets());
        console.log("totalBorrowAssets setelah 1 hari =", lendingPool.totalBorrowAssets());
    }
}
