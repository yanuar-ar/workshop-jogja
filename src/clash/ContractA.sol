// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract ContractA {
    address public implementation;

    constructor(address implementation_) {
        implementation = implementation_;
    }

    function increment() external {
        implementation.delegatecall(abi.encodeWithSignature("increment()"));
    }
}
