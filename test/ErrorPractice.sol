// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {ErrorPractice} from "../src/ErrorPractice.sol";
import {MockUSDC} from "../src/MockUSDC.sol";
import {ERC1967Proxy} from "openzeppelin-contracts/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract ErrorPracticeTest is Test {
    ErrorPractice public errorPractice;

    function setUp() public {
        errorPractice = new ErrorPractice();
    }

    function test_deposit() public {
        vm.expectRevert(abi.encodeWithSignature("NotOwner(address)", address(this)));
        errorPractice.deposit(2000);
    }
}
