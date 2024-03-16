// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import { Test } from "forge-std/Test.sol";
import {
    RhinestoneModuleKit,
    ModuleKitHelpers,
    ModuleKitUserOp,
    AccountInstance,
    UserOpData
} from "modulekit/ModuleKit.sol";
import { IERC7579Account } from "modulekit/Accounts.sol";
import { MODULE_TYPE_EXECUTOR, MODULE_TYPE_VALIDATOR } from "modulekit/external/ERC7579.sol";
import { ExecutionLib } from "erc7579/lib/ExecutionLib.sol";
import { SubscriptionModule } from "src/SubscriptionModule.sol";
import { Service } from "src/Service.sol";

import { IERC20 } from "forge-std/interfaces/IERC20.sol";

import "modulekit/ModuleKit.sol";
import "modulekit/Modules.sol";
import "modulekit/Mocks.sol";

import "forge-std/console.sol";

contract ExecutorTemplateTest is RhinestoneModuleKit, Test {
    using ModuleKitHelpers for *;
    using ModuleKitUserOp for *;

    Account internal account_signer = makeAccount("account_signer");
    Account internal service_signer = makeAccount("service_signer");

    // account and modules
    AccountInstance internal instance;
    SubscriptionModule internal sub_module;
    Service internal service;
    
    MockERC20 internal token;


    function setUp() public {
        init();

        token = new MockERC20();
        token.initialize("Mock Token", "MTK", 18);
        deal(address(token), instance.account, 100 ether);


        // Create the hook
        sub_module = new SubscriptionModule();
        vm.label(address(sub_module), "SubcriptionModule");

        // Create the account and install the hook
        instance = makeAccountInstance("SubscriptionModule");
        vm.deal(address(instance.account), 10 ether);
        
        instance.installModule({
            moduleTypeId: MODULE_TYPE_EXECUTOR,
            module: address(sub_module),
            data: ""
        });
        instance.installModule({
            moduleTypeId: MODULE_TYPE_VALIDATOR,
            module: address(sub_module),
            data: ""
        });

        // Create the service
        service = (new Service){value: 10 ether}(0.1 ether, 1000, sub_module);

        skip(100000); // Set our timestamp to something reasonably high
    }

    function testExec() public {
        // Create a target address and send some ether to it
        address target = makeAddr("target");
        uint256 value = 1 ether;

        // Get the current balance of the target
        uint256 prevBalance = target.balance;

        bytes memory callData = ExecutionLib.encodeSingle(target, value, "");

        // Execute the call
        instance.exec({
            target: address(sub_module),
            value: 0,
            callData: abi.encodeWithSelector(SubscriptionModule.execute.selector, callData)
        });

        // Check if the balance of the target has increased
        assertEq(target.balance, prevBalance + value);
    }

    function testExec2() public {
        // Create a target address and send some ether to it
        address target = makeAddr("target");
        uint256 value = 1 ether;

        // Get the current balance of the target
        uint256 prevBalance = target.balance;

        // Get the UserOp data (UserOperation and UserOperationHash)
        UserOpData memory userOpData = instance.getExecOps({
            target: target,
            value: value,
            callData: "",
            txValidator: address(sub_module)
        });

        // Set the signature
        bytes memory signature = hex"414141";
        userOpData.userOp.signature = signature;

        // Execute the UserOp
        userOpData.execUserOps();

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

        SubscriptionModule.SubscriptionParams memory params =
            SubscriptionModule.SubscriptionParams({ 
                target: address(service), value: value, frequency: frequency
            });


        instance.getExecOps({
            target: address(sub_module),
            value: 0,
            callData: abi.encodeCall(SubscriptionModule.subscribe, (params)),
            txValidator: address(instance.defaultValidator)
        }).execUserOps();

        bool success = sub_module.subscribe(params);
        require(success, "Didn't successfully subscribe");

        (SubscriptionModule.SubscriptionParams memory subscription_params, uint256 most_recent) = 
            sub_module.subscribers(IERC7579Account(instance.account),address(service));

        assertEq(address(subscription_params.target), address(service));
        assertEq(subscription_params.value, value);
        assertEq(subscription_params.frequency, frequency);
        assertEq(most_recent, block.timestamp - frequency);
    }

    // function testSubscribeInsufficientValue() public {
    //     try sub_module.subscribe(address(service), 0.01 ether, 1000) {
    //         assertEq(false, true, "Expected an error.");
    //     } catch Error(string memory message) {
    //         assertEq(message, "Minimum subscription value not reached");
    //     }
    // }

    // function testSubscribeInsufficientFreq() public {
    //     try sub_module.subscribe(address(service), 0.1 ether, 100) {
    //         assertEq(false, true, "Expected an error.");
    //     } catch Error(string memory message) {
    //         assertEq(message, "Subscription payment frequnecy too low");
    //     }
    // }

    function testSubscribeDrawFunds() public {
        uint256 frequency = 1000;
        uint256 value = 0.1 ether;

        SubscriptionModule.SubscriptionParams memory params = SubscriptionModule.SubscriptionParams({
            target: address(service), value: value, frequency: frequency
        });

        bool success = sub_module.subscribe(params);
        require(success, "Didn't successfully subscribe");

        console.log(address(service).balance);

        console.log(instance.account);

        instance.exec({
            target: address(sub_module),
            value: 0,
            callData: abi.encodeCall(
                SubscriptionModule.requestFunds,
                (address(service))
            )
        });

        // instance.getExecOps({
        //     target: address(sub_module),
        //     value: 0,
        //     callData: abi.encodeCall(SubscriptionModule.requestFunds, (address(service))),
        //     txValidator: address(instance.defaultValidator)
        // }).execUserOps();

        console.log(address(service).balance);


        // UserOpData memory userOpData = instance.getExecOps({
        //     target: address(this),
        //     value: 0,
        //     callData: ExecutionLib.encodeSingle(requestFunds, 0, ),
        //     txValidator: address(sub_module)
        // });

        // userOpData.execUserOps();

        // // Set the signature
        // bytes memory signature = hex"414141";
        // userOpData.userOp.signature = signature;

        // AccountInstance[] memory request = new AccountInstance[](1);
        // request[0] = instance;

        // instance.exec({
        //     target: address(sub_module),
        //     value: 0,
        //     callData: abi.encodeWithSelector(SubscriptionModule.requestFunds, )
        // });

        // success = service.collect(instance);
        // require(success, "User unsuccessful in providing payment");
    }
}
