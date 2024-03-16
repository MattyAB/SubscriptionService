// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "forge-std/console.sol";

import { ERC7579ExecutorBase } from "modulekit/Modules.sol";
import { IERC7579Account } from "modulekit/Accounts.sol";
import { ModeLib } from "erc7579/lib/ModeLib.sol";

contract SubscriptionModule is ERC7579ExecutorBase {
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

    struct SubscriptionParams {
        address target;
        uint256 value;
        uint256 frequency;
    }

    struct SubscriptionData {
        SubscriptionParams params;
        uint256 most_recent; // Most recent block height
    }

    SubscriptionData[] subscriptions_list;
    

    /*//////////////////////////////////////////////////////////////////////////
                                     MODULE LOGIC
    //////////////////////////////////////////////////////////////////////////*/

    /**
     * ERC-7579 does not define any specific interface for executors, so the
     * executor can implement any logic that is required for the specific usecase.
     */

    /*
     * Execute the given data
     * @dev This is an example function that can be used to execute arbitrary data
     * @dev This function is not part of the ERC-7579 standard
     * @param data The data to execute
     */
    function execute(bytes calldata data) external {
        IERC7579Account(msg.sender).executeFromExecutor(ModeLib.encodeSimpleSingle(), data);
    }

    function subscribe(SubscriptionParams memory params)
        public returns (bool success) {
        // require(value >= service.min_sub_value(), "Minimum subscription value not reached");
        // require(frequency <= service.sub_frequency(), "Subscription payment frequnecy too low");

        SubscriptionData memory this_data = SubscriptionData({
            params: params,
            most_recent: block.timestamp - params.frequency
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
            console.log(subscriptions_list[i].params.target);
            console.log(msg.sender);
            console.log(subscriptions_list[i].params.value);
            console.log(address(this).balance);

            if (subscriptions_list[i].params.target == msg.sender && subscriptions_list[i].params.value <= address(this).balance) {
                IERC7579Account smartAccount = IERC7579Account(msg.sender);

                // smartAccount.executeFromExecutor(
                //     ModeLib.encodeSimpleSingle(),
                //     ExecutionLib.encodeSingle(
                        
                //     )
                // )

                // (bool send, bytes memory data) = msg.sender.call{value: subscriptions_list[i].value}("");

                // require(send, "Send not executed successfully");

                subscriptions_list[i].most_recent += subscriptions_list[i].params.frequency;

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
        return "ExecutorTemplate";
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
        return typeID == TYPE_EXECUTOR;
    }
}
