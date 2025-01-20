// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract ErrorPractice {
    error NotOwner(address sender);
    error NotEnoughBalance(uint256 balance);

    address public owner = address(1);

    function deposit(uint256 amount) public {
        if (msg.sender != owner) revert NotOwner(msg.sender);
        if (amount < 1000) revert NotEnoughBalance(amount);
    }
}
