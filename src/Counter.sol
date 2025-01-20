// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Counter {
    uint256 public number; // 1
    uint256 public constant totalSupply = 1000; // 2

    uint256 public price; // 3

    address public owner; // 4

    constructor(uint256 _price) {
        owner = msg.sender;
        price = _price;
    }

    function setPrice(uint256 newPrice) public {
        require(msg.sender == owner, "Only owner can set price");
        price = newPrice;
    }

    function setOwner(address newOwner) public {
        require(msg.sender == owner, "Only owner can set owner");
        owner = newOwner;
    }

    function add(uint256 a, uint256 b) public pure returns (uint256) {
        return a + b;
    }

    function setNumber(uint256 newNumber) public {
        number = newNumber;
    }

    function increment() public {
        number++;
    }
}
