// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "forge-std/console.sol";

import { ERC7579HookBase } from "modulekit/modules/ERC7579HookBase.sol";

import { SubscriptionModule } from "./SubscriptionModule.sol";
import {
    RhinestoneModuleKit,
    ModuleKitHelpers,
    ModuleKitUserOp,
    AccountInstance,
    UserOpData
} from "modulekit/ModuleKit.sol";
import { IERC7579Account } from "modulekit/Accounts.sol";

import { ModeLib } from "erc7579/lib/ModeLib.sol";
import { ExecutionLib } from "erc7579/lib/ExecutionLib.sol";
import "modulekit/test/ModuleKitHelpers.sol";

contract Service {
    using ModuleKitHelpers for *;
    using ModuleKitUserOp for *;

    address owner;
    SubscriptionModule sub_module;

    uint256 public min_sub_value;
    uint256 public sub_frequency;


    mapping(address => uint256) public subscribers;

    modifier authorised() {
        require(msg.sender == owner, "Not authorised!");
        _;
    }

    constructor(uint256 _min_sub_value, uint256 _sub_frequency, SubscriptionModule _sub_module) payable {
        owner = msg.sender;
        min_sub_value = _min_sub_value;
        sub_frequency = _sub_frequency;
        sub_module = _sub_module;
    }

    function withdraw(address _to, uint256 value) public authorised {
        (bool sent, bytes memory data) = _to.call{value: value}("");
        require(sent, "Ether not withdrawn successfully");
    }

    // // Returns the time at which the subscriber last paid
    // function get_subscriber_recent(address subscriber) public returns(uint256 height) {
    //     return subscribers[subscriber];
    // }

    function collect(AccountInstance memory user) public authorised returns(bool) {
        console.log("Here");

        // UserOpData memory userOpData = user.getExecOps({
        //     target: address(this),
        //     value: 0.0001 ether,
        //     callData: "",
        //     txValidator: address(sub_module)
        // });

        // // Set the signature
        // bytes memory signature = hex"414141";
        // userOpData.userOp.signature = signature;

        // console.log("Hellow");

        // // Execute the UserOp
        // userOpData.execUserOps();

        // bytes memory callData = ExecutionLib.encodeSingle(address(this), 0.0001 ether, "");

        // console.log("part 1");

        // IERC7579Account(user).execute(ModeLib.encodeSimpleSingle(), callData);

        // user.exec({
        //     target: address(sub_module),
        //     value: 0,
        //     callData: abi.encodeCall(
        //         SubscriptionModule.requestFunds,
        //         (address(this))
        //     )
        // });

        console.log("There");

        return true;
    }

    // function collect(address[] memory users) public authorised returns(bool[] memory) {
    //     bool[] memory returner = new bool[](users.length);

    //     for (uint256 i = 0; i < users.length; i++) {
    //         if (subscribers[users[i].account] + sub_frequency <= block.timestamp) {
    //             // users[i].exec({
    //             //     target: address(sub_module),
    //             //     value: 0,
    //             //     callData: abi.encodeCall(
    //             //         SubscriptionModule.requestFunds,
    //             //         ()
    //             //     )
    //             // });

    //             // console.log(funds_received);

    //             // if (funds_received) {
    //             //     subscribers[address(users[i])] += sub_frequency;
    //             //     returner[i] = true;
    //             // } else {
    //             //     returner[i] = false;
    //             // }

    //             // // require(funds_received, "Funds not successfully retreived");

    //             // subscribers[address(users[i])] += sub_frequency;
    //         }
    //     }

    //     return returner;
    // }

    // function collect_initial() public returns(bool[] success) {

    // }
    
    ///// USER-SIDE FUNCTIONS

    // function notify_subscription() public {
    //     // Otherwise we'll run into all sorts of problems with the uint type.
    //     require(block.timestamp >= sub_frequency, "Timestamp too low");

    //     subscribers[msg.sender] = block.timestamp - sub_frequency;
    // }
}