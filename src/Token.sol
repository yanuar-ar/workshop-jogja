// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ERC20} from "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract Token is ERC20 {

  uint256 public constant MAX_SUPPLY = 100e40;
  address public owner;

  constructor() ERC20("Token", "TKN") {
    owner = msg.sender;
    _mint(msg.sender, 1000);
  }

  function mint(address to, uint256 amount) public {
    require(msg.sender == owner, "Only owner can mint");
    require(totalSupply() + amount <= MAX_SUPPLY, "Max supply exceeded");
    _mint(to, amount);
  }

}


