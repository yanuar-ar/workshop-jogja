// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {StorageSlot} from "../src/StorageSlot.sol";

contract StorageSlotTest is Test {
    StorageSlot public storageSlot;

    function setUp() public {
        storageSlot = new StorageSlot();
    }

    function test_readPriceFromStorage() public {
        uint256 price = storageSlot.readPriceFromStorage();
        assertEq(price, 9999);
    }

    function test_readIdListFromStorage() public {
        bool result = storageSlot.readIdListFromStorage(1);
        assertTrue(result);
    }

    function test_mainStorageLocationSlotNumber() public {
        console.logBytes32(storageSlot.mainStorageLocationSlotNumber());
    }

}
