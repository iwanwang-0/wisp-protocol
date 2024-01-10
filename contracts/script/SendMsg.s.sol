// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import {CRCOutbox} from "../src/crc-messages/CRCOutbox.sol";
import {Types} from "../src/crc-messages/libraries/Types.sol";

contract SendMsg is Script {
    function run() external {
        address outboxAddr = address(0x5380fDE220CFC9cbad8F99E19d2E875d1aB36081);
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        Types.CRCMessage memory message = Types.CRCMessage(
            1,
            vm.envUint("CHAIN_ID"), // destination chian id
            0,
            msg.sender,
            address(1),
            "Hello world",
            0.1 ether,
            0.1 ether,
            ""
        );

        vm.startBroadcast(deployerPrivateKey);
        CRCOutbox outbox = CRCOutbox(outboxAddr);
        outbox.sendMessage(message);
        vm.stopBroadcast();
    }
}