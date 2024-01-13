// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import {CRCOutbox} from "../src/crc-messages/CRCOutbox.sol";
import {Types} from "../src/crc-messages/libraries/Types.sol";

contract SendMsg is Script {
    function run() external {
        address outboxAddr = address(0xd3ceBfFAc4c7FFc78b0645713719D259F2EBC2D6);
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        Types.CRCMessage memory message = Types.CRCMessage(
            1,
            vm.envUint("CHAIN_ID"), // destination chian id
            3,
            msg.sender,
            address(0x3091078046ECFeB8a06d392E90b3eF608F21ED65),
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