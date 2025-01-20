// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {ChainlinkPrice} from "../src/ChainlinkPrice.sol";

contract ChainlinkPriceTest is Test {
    ChainlinkPrice public chainlinkPrice;

    function setUp() public {
        vm.createSelectFork("https://eth-mainnet.g.alchemy.com/v2/Ea4M-V84UObD22z2nNlwDD9qP8eqZuSI");
        chainlinkPrice = new ChainlinkPrice();
    }

    function test_getPrice() public {
        console.log(chainlinkPrice.getPrice());
    }
}
