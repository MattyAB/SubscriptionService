// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "forge-std/console.sol";

import { IERC20 } from "forge-std/interfaces/IERC20.sol";
import { ERC7579ExecutorBase, ERC7579ValidatorBase, ERC7579HookBase } from "modulekit/Modules.sol";
import { IERC7579Account } from "modulekit/Accounts.sol";
import { ModeLib } from "erc7579/lib/ModeLib.sol";
import { ExecutionLib } from "erc7579/lib/ExecutionLib.sol";
import { PackedUserOperation } from "modulekit/ModuleKit.sol";
import { SignatureCheckerLib } from "solady/src/utils/SignatureCheckerLib.sol";

contract SubscriptionModule is ERC7579ExecutorBase, ERC7579ValidatorBase {
    /*//////////////////////////////////////////////////////////////////////////
                                     CONFIG
    //////////////////////////////////////////////////////////////////////////*/

    /* Initialize the module with the given data
     * @param data The data to initialize the module with
     */
    function onInstall(bytes calldata data) external override {
        // subscribers[msg.sender] = mapping(address => SubscriptionData);
    }

    /* De-initialize the module with the given data
     * @param data The data to de-initialize the module with
     */
    function onUninstall(bytes calldata data) external override {
        // delete subscribers[msg.sender];
    }

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

    mapping(IERC7579Account => mapping(address => SubscriptionData)) public subscribers;
    

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
        SubscriptionData memory this_data = SubscriptionData({
            params: params,
            most_recent: block.timestamp - params.frequency
        });

        subscribers[IERC7579Account(msg.sender)][params.target] = this_data;

        return true;
    }

    function unsubscribe(address service) public returns (bool success) {
        delete subscribers[IERC7579Account(msg.sender)][service];
    }

    function validateUserOp(
        PackedUserOperation calldata userOp,
        bytes32 userOpHash
    )
        external
        view
        override
        returns (ValidationData)
    {
        console.log("Called");

        return ValidationData.wrap(0);
    }

    function isValidSignatureWithSender(
        address sender,
        bytes32 hash,
        bytes calldata data
    )
        external
        view
        override
        returns (bytes4)
    {
        console.log("Called");

        return EIP1271_FAILED;
    }

    function requestFunds(address service_addr) public returns(bool success) {

        if (subscribers[IERC7579Account(msg.sender)][service_addr].params.value <= msg.sender.balance &&
            subscribers[IERC7579Account(msg.sender)][service_addr].most_recent + 
            subscribers[IERC7579Account(msg.sender)][service_addr].params.frequency <= block.timestamp) {
            IERC7579Account smartAccount = IERC7579Account(msg.sender);

            

            bytes[] memory info = smartAccount.executeFromExecutor(
                ModeLib.encodeSimpleSingle(),
                ExecutionLib.encodeSingle(
                    service_addr,
                    subscribers[IERC7579Account(msg.sender)][service_addr].params.value,
                    ""
                )
            );

            subscribers[IERC7579Account(msg.sender)][service_addr].most_recent += subscribers[IERC7579Account(msg.sender)][service_addr].params.frequency;
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
        return typeID == TYPE_EXECUTOR;
    }
}
