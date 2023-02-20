// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

/**
 * @title Types
 * @notice Contains various types used throughout the Optimism contract system.
 */
library Types {
    /**
     * @notice Input structure for sending a CRC message
     */
    struct CRCMessage {
        uint8 version; // Version of the protocol this message confirms to
        uint256 destinationChainId; // The “chain id” of the network this message is intended for
        uint64 nonce; // A nonce used as an anti-replay attack mechanism. Randomly generated by the user.
        address user; // An arbitrary address that is the actual sender of the message. Can be used by smart contracts that automate the messaging to specify the address of the user or be the same as the msg.sender.
        address target; // The address of a contract that the CRC Smart contract will send the Payload to when finalizing the CRC.
        bytes payload; // Arbitrary bytes that will be sent as calldata to the Execution Target address in the destination contract when finalizing the CRC.
        uint256 stateRelayFee; // Fee in wei that the sender will be locking as a reward for the first relayer that brings the state containing this information inside the destination network.
        uint256 deliveryFee; // Fee in wei that the sender will be locking as a reward for the first relayer that triggers the execution of the CRC delivery. Could be 0 if the Sender is willing to finalize it itself.
        bytes extra; // Arbitrary bytes that will be sent alongside the data for dapps to make sense of
    }

    /**
     * @notice Complete CRCMessage envelop including the sender. Used upon receiving of CRCMessages
     */
    struct CRCMessageEnvelope {
        CRCMessage message; // CRC Message
        address sender; // The sender of the message
    }
}
