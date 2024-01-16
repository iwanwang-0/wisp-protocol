// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import {CRCOutbox} from "../src/crc-messages/CRCOutbox.sol";
import {Types} from "../src/crc-messages/libraries/Types.sol";
import "forge-std/console.sol";

contract SendMsg is Script {
    function run(string memory network) external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        address outboxAddr;
        uint256 chainId;
        address receiverDemo;

        if (keccak256(abi.encodePacked(network)) == keccak256(abi.encodePacked("optimism-sepolia"))) {
            outboxAddr = vm.envAddress("OPTIMISM_SEPOLIA_OUTBOX_ADDRESS");
            chainId = vm.envUint("BASE_SEPOLIA_CHAIN_ID");
            receiverDemo = vm.envAddress("BASE_SEPOLIA_RECEIVER_DEMO");
        } else if (keccak256(abi.encodePacked(network)) == keccak256(abi.encodePacked("base-sepolia"))) {
            outboxAddr = vm.envAddress("BASE_SEPOLIA_OUTBOX_ADDRESS");
            chainId = vm.envUint("OPTIMISM_SEPOLIA_CHAIN_ID");
            receiverDemo = vm.envAddress("OPTIMISM_SEPOLIA_RECEIVER_DEMO");
        } else {
            revert("Unknown network");
        }

        Types.CRCMessage memory message = Types.CRCMessage(
            1,
            chainId, // destination chian id
            1,
            msg.sender,
            receiverDemo,
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