// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract DepositModule {
    struct DepositModuleStorage {
        mapping(address => uint256) balances;
    }

    // keccak256(abi.encode(uint256(keccak256("deposit.storage.batch2")) - 1)) & ~bytes32(uint256(0xff));
    bytes32 private constant DEPOSIT_STORAGE_LOCATION =
        0xd86853f7172766d138d7bc8887da095a6aed14a32dd1551bcd002fc36269b200;

    function _getDepositModuleStorage() private pure returns (DepositModuleStorage storage $) {
        assembly {
            $.slot := DEPOSIT_STORAGE_LOCATION
        }
    }

    function deposit(uint256 amount) external {
        DepositModuleStorage storage $ = _getDepositModuleStorage();
        $.balances[msg.sender] += amount;
    }
}
