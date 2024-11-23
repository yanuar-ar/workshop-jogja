// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {IERC20} from "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import {Swap} from "../src/Swap.sol";

contract SwapTest is Test {

  address weth = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
  Swap public swap;

  address alice = makeAddr("alice");
  address bob = makeAddr("bob");
  address charlie = makeAddr("charlie");

  function setUp() public {
    vm.createSelectFork("https://eth-mainnet.g.alchemy.com/v2/Ea4M-V84UObD22z2nNlwDD9qP8eqZuSI",21197642);

    swap = new Swap();

    deal(weth,address(this), 100e18);

    deal(weth,alice, 100e18);
    deal(weth,bob, 100e18);
    deal(weth,charlie, 100e18);
  }

  function test_swapETHtoPepe() public {

    // alice swaps 100 WETH to PEPE
    vm.startPrank(alice);
    IERC20(weth).approve(address(swap), 100e18);
    uint256 amountOut = swap.swapETHtoPepe(100e18, 0);
    console.log(amountOut);

    // bob swaps 100 WETH to PEPE
    vm.startPrank(bob);
    IERC20(weth).approve(address(swap), 100e18);
    amountOut = swap.swapETHtoPepe(100e18, 13414278116595569577793579400);
    console.log(amountOut);

    // charlie swaps 100 WETH to PEPE
    vm.startPrank(charlie);
    IERC20(weth).approve(address(swap), 100e18);
    amountOut = swap.swapETHtoPepe(100e18, 13414278116595569577793579400);
    console.log(amountOut);
  }

}
