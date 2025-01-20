// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract VaultEvent {
    event Deposit(address user, uint256 amount);
    event Withdraw(address user, uint256 amount);

    function deposit(uint256 amount) public {
        emit Deposit(msg.sender, amount);
    }

    function withdraw(uint256 amount) public {
        emit Withdraw(msg.sender, amount);
    }
}
