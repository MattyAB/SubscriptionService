// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import { Test } from "forge-std/Test.sol";
import {
    RhinestoneModuleKit,
    ModuleKitHelpers,
    ModuleKitUserOp,
    AccountInstance
} from "modulekit/ModuleKit.sol";
import { MODULE_TYPE_HOOK } from "modulekit/external/ERC7579.sol";
import { SubscriptionModule } from "src/SubscriptionModule.sol";
import { Service } from "src/Service.sol";

contract SubscriptionModuleTest is RhinestoneModuleKit, Test {
    using ModuleKitHelpers for *;
    using ModuleKitUserOp for *;

    // account and modules
    AccountInstance internal instance;
    SubscriptionModule internal sub_module;
    Service internal service;

    function setUp() public {
        init();

        // Create the hook
        sub_module = new SubscriptionModule();
        vm.label(address(sub_module), "SubcriptionModule");

        // Create the account and install the hook
        instance = makeAccountInstance("SubscriptionModule");
        vm.deal(address(instance.account), 10 ether);
        instance.installModule({ moduleTypeId: MODULE_TYPE_HOOK, module: address(sub_module), data: "" });

        // Create the service
        service = (new Service){value: 10 ether}();
    }

    function testExec() public {
        // Create a target address and send some ether to it
        address target = makeAddr("target");
        uint256 value = 1 ether;

        // Get the current balance of the target
        uint256 prevBalance = target.balance;

        // Execute the call
        instance.exec({ target: target, value: value, callData: "" });

        // Check if the balance of the target has increased
        assertEq(target.balance, prevBalance + value);
    }

    function testWithdraw() public {
        uint256 prev_value = address(this).balance;

        service.withdraw(instance, 1 ether);

        assertEq(prev_value + 1 ether, address(this).balance);
    }

    // function testSubscribe() public {
        
    // }
}