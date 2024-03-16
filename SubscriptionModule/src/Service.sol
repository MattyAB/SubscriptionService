// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "forge-std/console.sol";

import { ERC7579HookBase } from "modulekit/modules/ERC7579HookBase.sol";

contract Service {
    address owner;

    modifier authorised() {
        require(msg.sender == owner, "Not authorised!");
        _;
    }

    constructor() payable {
        owner = msg.sender;
    }

    function withdraw(address _to, uint256 value) public authorised {
        (bool sent, bytes memory data) = _to.call{value: value}("");
        console.log(_to);
        console.log(_to.balance);
        require(sent, "Ether not withdrawn successfully");
    }
}