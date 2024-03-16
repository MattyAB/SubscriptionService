// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "forge-std/console.sol";

import { ERC7579HookBase } from "modulekit/modules/ERC7579HookBase.sol";

import { SubscriptionModule } from "./SubscriptionModule.sol";

contract Service {
    address owner;

    uint256 public min_sub_value;
    uint256 public sub_frequency;

    mapping(address => uint256) public subscribers;

    modifier authorised() {
        require(msg.sender == owner, "Not authorised!");
        _;
    }

    constructor(uint256 _min_sub_value, uint256 _sub_frequency) payable {
        owner = msg.sender;
        min_sub_value = _min_sub_value;
        sub_frequency = _sub_frequency;
    }

    function withdraw(address _to, uint256 value) public authorised {
        (bool sent, bytes memory data) = _to.call{value: value}("");
        require(sent, "Ether not withdrawn successfully");
    }

    // // Returns the time at which the subscriber last paid
    // function get_subscriber_recent(address subscriber) public returns(uint256 height) {
    //     return subscribers[subscriber];
    // }

    function collect(SubscriptionModule[] memory users) public authorised returns(bool[] memory) {
        bool[] memory returner = new bool[](users.length);


        for (uint256 i = 0; i < users.length; i++) {
            if (subscribers[address(users[i])] + sub_frequency <= block.timestamp) {
                bool funds_received = users[i].requestFunds();

                console.log(funds_received);

                if (funds_received) {
                    subscribers[address(users[i])] += sub_frequency;
                    returner[i] = true;
                } else {
                    returner[i] = false;
                }

                // // require(funds_received, "Funds not successfully retreived");

                // subscribers[address(users[i])] += sub_frequency;
            }
        }

        return returner;
    }

    // function collect_initial() public returns(bool[] success) {

    // }
    
    ///// USER-SIDE FUNCTIONS

    // function notify_subscription() public {
    //     // Otherwise we'll run into all sorts of problems with the uint type.
    //     require(block.timestamp >= sub_frequency, "Timestamp too low");

    //     subscribers[msg.sender] = block.timestamp - sub_frequency;
    // }
}