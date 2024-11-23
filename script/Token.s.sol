// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {Token} from "../src/Token.sol";

contract TokenScript is Script {
    Token public token;

    function setUp() public {}

    function run() public {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        token = new Token();
        console.log("Token deployed at", address(token));

        vm.stopBroadcast();
    }
}
