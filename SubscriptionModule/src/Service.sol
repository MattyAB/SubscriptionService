// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "forge-std/console.sol";

import { ERC7579HookBase } from "modulekit/modules/ERC7579HookBase.sol";

contract Service {
    address owner;

    uint256 public min_sub_value;
    uint256 public sub_frequency;

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
}