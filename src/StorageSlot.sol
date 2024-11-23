// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract StorageSlot {
    // forge inspect StorageSlot storage --pretty
    uint16 public active;
    bool public paused;
    uint256 public price = 9999;
    address public owner;
    mapping(uint256 => bool) public idList;

    struct MainStorage {
        // 100000
        address owner;
        uint256 balanceOwner;
    }

    // keccak256(abi.encode(uint256(keccak256("latihan.solidity.batch2")) - 1)) & ~bytes32(uint256(0xff));
    bytes32 private constant MAIN_STORAGE_LOCATION = 0x295a92aa5560ee40e48845ced83326d13fbffc2172c9436f0573bdee710c3b00;

    constructor() {
        idList[1] = true;
    }

    function _getMainStorage() private pure returns (MainStorage storage $) {
        assembly {
            $.slot := MAIN_STORAGE_LOCATION
        }
    }

    function setOwner(address _owner) public {
        MainStorage storage $ = _getMainStorage();
        $.owner = _owner;
        $.balanceOwner = 100000;
    }

    function getOwner() public view returns (address owner) {
        MainStorage storage $ = _getMainStorage();
        return $.owner;
    }

    function balanceOwner() public view returns (uint256 balance) {
        MainStorage storage $ = _getMainStorage();
        return $.balanceOwner;
    }

    function mainStorageLocationSlotNumber() public pure returns (bytes32 slot) {
        return MAIN_STORAGE_LOCATION;
    }

    function readIdListFromStorage(uint256 id) public view returns (bool result) {
        // keccak256(key, slot)
        bytes32 slot = keccak256(abi.encode(id, 3));

        assembly {
            result := sload(slot)
        }
    }

    function readPriceFromStorage() public view returns (uint256 price) {
        assembly {
            price := sload(1)
        }
    }
}
