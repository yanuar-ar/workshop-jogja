// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {VaultUpgradeableV1} from "../src/proxy/VaultUpgradeableV1.sol";
import {VaultUpgradeableV2} from "../src/proxy/VaultUpgradeableV2.sol";
import {MockUSDC} from "../src/MockUSDC.sol";
import {ERC1967Proxy} from "openzeppelin-contracts/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract VaultUpgradeableTest is Test {
    VaultUpgradeableV1 public vault;
    MockUSDC public usdc;

    function setUp() public {
        usdc = new MockUSDC();

        address implementationV1 = address(new VaultUpgradeableV1());
        address implementationV2 = address(new VaultUpgradeableV2());

        address proxy =
            address(new ERC1967Proxy(implementationV1, abi.encodeWithSignature("initialize(address)", address(usdc))));

        vault = VaultUpgradeableV1(proxy);

        usdc.mint(address(this), 100e18);
    }

    function test_upgrade() public {
        vault.upgradeToAndCall(address(new VaultUpgradeableV2()), "");
        assertEq(vault.version(), 2);
    }

    function test_version() public {
        assertEq(vault.version(), 1);
    }

    function test_deposit() public {
        usdc.approve(address(vault), 100e18);
        vault.deposit(100e18);
    }
}
