// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {IERC20} from "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import {Flashloan} from "../src/Flashloan.sol";
contract FlashloanTest is Test {

  address weth = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
  address aETH = 0x4d5F47FA6A74757f35C14fD3a6Ef8E3C9BC514E8;    
  Flashloan public flashloan;


  function setUp() public {
    vm.createSelectFork("https://eth-mainnet.g.alchemy.com/v2/Ea4M-V84UObD22z2nNlwDD9qP8eqZuSI",21197642);

    flashloan = new Flashloan();

    deal(weth,address(this), 1e18);
  }

  function test_flashloan() public {
    IERC20(weth).approve(address(flashloan), 1e18);
    flashloan.loopingSupply();
    console.log(IERC20(aETH).balanceOf(address(flashloan)));
  }

}
