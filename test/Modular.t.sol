// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Main} from "../src/modular/Main.sol";
import {DepositModule} from "../src/modular/DepositModule.sol";

contract ModularTest is Test {
    Main public main;
    DepositModule public depositModule;

    function setUp() public {
        depositModule = new DepositModule();
        main = new Main(address(depositModule));
    }

    function test_deposit() public {
        main.deposit(100);
        assertEq(main.getBalance(address(this)), 100);
    }
}
