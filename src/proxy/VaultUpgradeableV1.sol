// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ERC20Upgradeable} from "openzeppelin-contracts-upgradeable/contracts/token/ERC20/ERC20Upgradeable.sol";
import {Initializable} from "openzeppelin-contracts-upgradeable/contracts/proxy/utils/Initializable.sol";
import {UUPSUpgradeable} from "openzeppelin-contracts-upgradeable/contracts/proxy/utils/UUPSUpgradeable.sol";
import {IERC20} from "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

contract VaultUpgradeableV1 is Initializable, ERC20Upgradeable, UUPSUpgradeable {
    address public usdc;
    address public owner;

    constructor() {
        _disableInitializers();
    }

    function initialize(address _usdc) public initializer {
        __ERC20_init("Deposito", "DEPO");
        usdc = _usdc;
        owner = msg.sender;
    }

    function version() public pure returns (uint256) {
        return 1;
    }

    function _authorizeUpgrade(address newImplementation) internal override {
        require(msg.sender == owner, "Only owner can upgrade");
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
        IERC20(usdc).transferFrom(msg.sender, address(this), amount);
    }

    function withdraw(uint256 shares) public {
        uint256 totalAssets = IERC20(usdc).balanceOf(address(this));
        uint256 amount = (shares * totalAssets) / totalSupply();
        _burn(msg.sender, shares);
        IERC20(usdc).transfer(msg.sender, amount);
    }
}
