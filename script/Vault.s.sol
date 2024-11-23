// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {Vault} from "../src/Vault.sol";

contract VaultScript is Script {
    Vault public vault;

    function setUp() public {}

    function run() public {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

       console.log("Alice's address:", vm.addr(vm.envUint("PRIVATE_KEY")));


        vault = new Vault(0x4c9EDD5852cd905f086C759E8383e09bff1E68B3);
        console.log("Vault deployed at", address(vault));



        vm.stopBroadcast();
    }
}
