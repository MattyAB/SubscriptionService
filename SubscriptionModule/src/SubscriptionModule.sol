// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "forge-std/console.sol";

import { ERC7579HookBase } from "modulekit/modules/ERC7579HookBase.sol";
// import { Service } from "./Service.sol";

contract SubscriptionModule is ERC7579HookBase {
    /*//////////////////////////////////////////////////////////////////////////
                                     CONFIG
    //////////////////////////////////////////////////////////////////////////*/

    /* Initialize the module with the given data
     * @param data The data to initialize the module with
     */
    function onInstall(bytes calldata data) external override { }

    /* De-initialize the module with the given data
     * @param data The data to de-initialize the module with
     */
    function onUninstall(bytes calldata data) external override { }

    /*
     * Check if the module is initialized
     * @param smartAccount The smart account to check
     * @return true if the module is initialized, false otherwise
     */
    function isInitialized(address smartAccount) external view returns (bool) { }

    /*//////////////////////////////////////////////////////////////////////////
                                     STORAGE
    //////////////////////////////////////////////////////////////////////////*/

    struct SubscriptionData {
        address target;
        uint256 value;
        uint256 frequency;
        uint256 most_recent; // Most recent block height
    }

    SubscriptionData[] subscriptions_list;

    /*//////////////////////////////////////////////////////////////////////////
                                     MODULE LOGIC
    //////////////////////////////////////////////////////////////////////////*/

    /**
     * Pre-checks an execution
     * @param msgSender The sender of the execution to the account
     * @param msgData The data of the execution
     * @return hookData The data to be used in the post-check
     */
    function preCheck(
        address msgSender,
        bytes calldata msgData
    )
        external
        override
        returns (bytes memory hookData)
    {
        hookData = abi.encode(true);
    }

    /**
     * Post-checks an execution
     * @param hookData The data from the pre-check
     * @return success true if the execution is successful, false otherwise
     */
    function postCheck(bytes calldata hookData) external override returns (bool success) {
        (success) = abi.decode(hookData, (bool));
    }

    function subscribe(address service, uint256 value, uint256 frequency)
        public returns (bool success) {
        // require(value >= service.min_sub_value(), "Minimum subscription value not reached");
        // require(frequency <= service.sub_frequency(), "Subscription payment frequnecy too low");

        SubscriptionData memory this_data = SubscriptionData({
            target: service,
            value: value,
            frequency: frequency,
            most_recent: block.timestamp - frequency
        });

        subscriptions_list.push(this_data);

        return true;
    }

    function getSubscriptions()
        public view returns (SubscriptionData[] memory subscriptionData) {
        return subscriptions_list;
    }

    function requestFunds() public returns(bool success) {
        for (uint256 i = 0; i < subscriptions_list.length; i++) {
            if (subscriptions_list[i].target == msg.sender && subscriptions_list[i].value <= address(this).balance) {
                (bool send, bytes memory data) = msg.sender.call{value: subscriptions_list[i].value}("");

                require(send, "Send not executed successfully");

                subscriptions_list[i].most_recent += subscriptions_list[i].frequency;

                return true;
            }
        }

        return false;
    }

    /*//////////////////////////////////////////////////////////////////////////
                                     METADATA
    //////////////////////////////////////////////////////////////////////////*/

    /**
     * The name of the module
     * @return name The name of the module
     */
    function name() external pure returns (string memory) {
        return "SubscriptionModule";
    }

    /**
     * The version of the module
     * @return version The version of the module
     */
    function version() external pure returns (string memory) {
        return "0.0.1";
    }

    /* 
        * Check if the module is of a certain type
        * @param typeID The type ID to check
        * @return true if the module is of the given type, false otherwise
        */
    function isModuleType(uint256 typeID) external pure override returns (bool) {
        return typeID == TYPE_HOOK;
    }
}
