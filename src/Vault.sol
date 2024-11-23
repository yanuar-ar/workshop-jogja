// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ERC20} from "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import {IERC20} from "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

contract Vault is ERC20 {

  address public immutable usdc;
  address public owner;

  constructor(address _usdc) ERC20("Deposito", "DEPO") {
    usdc = _usdc;
    owner = msg.sender;
  }

  function deposit(uint256 amount) public {
    uint256 shares = 0;
    uint256 totalAssets = IERC20(usdc).balanceOf(address(this));

    if (totalSupply() == 0) {
        shares = amount;
    } else {
        shares = (amount * totalSupply()) / totalAssets;
    }

    _mint(msg.sender, shares);
    IERC20(usdc).transferFrom(msg.sender, address(this), amount);
  }

  function distributeYield(uint256 amount) public { 
    require(msg.sender == owner, "Only owner can distribute yield");
    IERC20(usdc).transferFrom(msg.sender,address(this), amount);
  }

  function withdraw(uint256 shares) public {
    uint256 totalAssets = IERC20(usdc).balanceOf(address(this));
    uint256 amount = (shares * totalAssets) / totalSupply();
    _burn(msg.sender, shares);
    IERC20(usdc).transfer(msg.sender, amount);
  }
}


