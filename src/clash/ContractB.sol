// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract ContractB {
    address public implementation;
    uint256 public value;

    function increment() external {
        value++;
    }
}
