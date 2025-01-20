// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {IERC20} from "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

contract LendingPool {
    address public usdc = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    address public wbtc = 0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599;

    uint256 public totalSupplyAssets;
    uint256 public totalSupplyShares;
    uint256 public totalBorrowAssets;
    uint256 public totalBorrowShares;

    mapping(address => uint256) public userSupplyShares;
    mapping(address => uint256) public userBorrowShares;
    mapping(address => uint256) public userCollaterals;

    uint256 lastAccrued;

    constructor() {
        lastAccrued = block.timestamp;
    }

    function supply(uint256 amount) public {
        IERC20(usdc).transferFrom(msg.sender, address(this), amount);

        _accrueInterest();

        uint256 shares = 0;
        if (totalSupplyAssets == 0) {
            shares = amount;
        } else {
            shares = (amount * totalSupplyShares) / totalSupplyAssets;
        }

        totalSupplyAssets += amount;
        totalSupplyShares += shares;
        userSupplyShares[msg.sender] += shares;
    }

    function withdraw(uint256 shares) public {
        _accrueInterest();

        uint256 amount = (shares * totalSupplyAssets) / totalSupplyShares;

        totalSupplyAssets -= amount;
        totalSupplyShares -= shares;
        userSupplyShares[msg.sender] -= shares;
        IERC20(usdc).transfer(msg.sender, amount);
    }

    function supplyCollateral(uint256 amount) public {
        _accrueInterest();

        IERC20(wbtc).transferFrom(msg.sender, address(this), amount);
        userCollaterals[msg.sender] += amount;
    }

    function withdrawCollateral(uint256 amount) public {
        _accrueInterest();

        IERC20(wbtc).transfer(msg.sender, amount);
        userCollaterals[msg.sender] -= amount;
    }

    function borrow(uint256 amount) public {
        _accrueInterest();

        uint256 shares = 0;
        if (totalBorrowAssets == 0) {
            shares = amount;
        } else {
            shares = (amount * totalBorrowShares) / totalBorrowAssets;
        }

        totalBorrowAssets += amount;
        totalBorrowShares += shares;
        userBorrowShares[msg.sender] += shares;

        IERC20(usdc).transfer(msg.sender, amount);
    }

    function repay(uint256 shares) public {
        _accrueInterest();

        uint256 amount = (shares * totalBorrowAssets) / totalBorrowShares;

        totalBorrowAssets -= amount;
        totalBorrowShares -= shares;
        userBorrowShares[msg.sender] -= shares;

        IERC20(usdc).transferFrom(msg.sender, address(this), amount);
    }

    function accrueInterest() public {
        _accrueInterest();
    }

    function _accrueInterest() internal {
        uint256 borrowRate = 5;

        uint256 interestPerYear = totalBorrowAssets * borrowRate / 100;
        uint256 elapsedTime = block.timestamp - lastAccrued;

        uint256 interest = (interestPerYear * elapsedTime) / 365 days;

        totalBorrowAssets += interest;
        totalSupplyAssets += interest;

        lastAccrued = block.timestamp;
    }
}
