// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/crc-messages/CRCInbox.sol";

contract Settings is Script {
    function setRegistry(string memory network) external {
        address inboxAddress;
        address outbox;
        uint256 chainId;

        if (keccak256(abi.encodePacked(network)) == keccak256(abi.encodePacked("optimism-goerli"))) {
            inboxAddress = vm.envAddress("OPTIMISM_GOERLI_CRC_INBOX");
            outbox = vm.envAddress("BASE_GOERLI_OUTBOX_ADDRESS");
            chainId = vm.envUint("BASE_GOERLI_CHAIN_ID");
        } else if (keccak256(abi.encodePacked(network)) == keccak256(abi.encodePacked("base-goerli"))) {
            inboxAddress = vm.envAddress("BASE_GOERLI_CRC_INBOX");
            outbox = vm.envAddress("OPTIMISM_GOERLI_OUTBOX_ADDRESS");
            chainId = vm.envUint("OPTIMISM_GOERLI_CHAIN_ID");
        } else {
            revert("Unknown network");
        }

        _setRegistry(inboxAddress, outbox, chainId);
    }

    function _setRegistry(address inboxAddress, address outbox, uint256 chainId) internal {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        CRCInbox inbox = CRCInbox(inboxAddress);
        inbox.setChainIdFor(outbox, chainId);
        vm.stopBroadcast();
    }
}
