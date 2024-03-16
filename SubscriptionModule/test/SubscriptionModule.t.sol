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

import "forge-std/console.sol";

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
        service = (new Service){value: 10 ether}(0.1 ether, 1000);

        skip(100000); // Set our timestamp to something reasonably high
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
        address recipient; // Declaring an empty address

        service.withdraw(recipient, 1 ether);

        assertEq(1 ether, recipient.balance);
    }

    function testSubscribe() public {
        uint256 frequency = 1000;
        uint256 value = 0.1 ether;

        bool success = sub_module.subscribe(service, value, frequency);

        // SubscriptionModule.SubscriptionData memory data = SubscriptionModule.SubscriptionData({
        //     target: address(service), value: 0.01 ether, frequency: 10000, most_recent: block.number
        // });
        
        console.log(service.get_subscriber_recent(address(sub_module)));

        SubscriptionModule.SubscriptionData[] memory data_returned = sub_module.getSubscriptions();

        assertEq(address(data_returned[0].target), address(service));
        assertEq(data_returned[0].value, value);
        assertEq(data_returned[0].frequency, frequency);
        assertEq(data_returned[0].most_recent, block.timestamp - frequency);

        assertEq(service.get_subscriber_recent(address(sub_module)), block.timestamp - frequency);
    }

    function testSubscribeInsufficientValue() public {
        try sub_module.subscribe(service, 0.01 ether, 1000) {
            assertEq(false, true, "Expected an error.");
        } catch Error(string memory message) {
            assertEq(message, "Minimum subscription value not reached");
        }
    }

    // function testSubscribeInsufficientFrequency() public {
    //     bool success = sub_module.subscribe(service, 0.1 ether, 10000);
        

    // }
}
