// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {IMessageReceiver} from "./interfaces/IMessageReceiver.sol";
import {Types} from "./libraries/Types.sol";

contract ReceiverDemo is IMessageReceiver {

    struct ReceivedMsg {
        uint256 sourceChainId;
        bytes message;
    }

    ReceivedMsg[] public msgs;

    constructor() {

    }

    function receiveMessage(
        Types.CRCMessageEnvelope calldata envelope,
        uint256 sourceChainId
    ) external returns (bool success) {
        msgs.push(ReceivedMsg(sourceChainId, envelope.message.payload));
        return true;
    }
}