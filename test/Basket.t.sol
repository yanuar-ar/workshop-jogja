// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {IERC20} from "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import {Basket} from "../src/Basket.sol";

contract BasketTest is Test {

  address public usdc = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
  address public weth = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
  address public wbtc = 0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599;

  Basket public basket;


  function setUp() public {
    vm.createSelectFork("https://eth-mainnet.g.alchemy.com/v2/Ea4M-V84UObD22z2nNlwDD9qP8eqZuSI",21197642);

    basket = new Basket();

    deal(usdc,address(this), 1000e6);
  }

  function test_deposit() public {
    IERC20(usdc).approve(address(basket), 1000e6);
    basket.deposit(1000e6);

    uint256 shares = basket.balanceOf(address(this));

    basket.withdraw(shares/2);
    basket.withdraw(shares/2);

    console.log(IERC20(usdc).balanceOf(address(this)));
  }

}
