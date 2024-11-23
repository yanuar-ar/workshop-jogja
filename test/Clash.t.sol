// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";

import {ContractA} from "../src/clash/ContractA.sol";
import {ContractB} from "../src/clash/ContractB.sol";

contract ClashTest is Test {
    ContractA public contractA;
    ContractB public contractB;

    function setUp() public {
        contractB = new ContractB();
        contractA = new ContractA(address(contractB));
    }

    function test_clash() public {
        console.log(address(contractA.implementation()));
        console.log(uint256(uint160(address(contractA.implementation()))));
        contractA.increment();
        console.log(address(contractA.implementation()));
        console.log(uint256(uint160(address(contractA.implementation()))));
    }
}
