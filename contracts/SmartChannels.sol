// SPDX-License-Identifier: CC-PDDC
pragma solidity ^0.8.0;

import {Sapphire} from "@oasisprotocol/sapphire-contracts/contracts/Sapphire.sol";
import "@oasisprotocol/sapphire-contracts/contracts/EthereumUtils.sol";

struct Channel {
    address[] members;
    uint256[] balances;
    bytes32 guid;
    uint256 sequence;
}

contract SmartChannel {
    address public identity;
    bytes32 private secretKey;

    constructor () {
        (identity,secretKey) = EthereumUtils.generateKeypair();
    }

    function createChannel (address[] calldata members)
        public view returns (bytes memory encoded, SignatureRSV memory sig)
    {
        uint256[] memory balances = new uint256[](members.length);
        bytes32 guid = bytes32(Sapphire.randomBytes(32, ""));
        Channel memory channel = Channel(members, balances, guid, 0);
        encoded = abi.encode(channel);
        sig = EthereumUtils.sign(identity, secretKey, keccak256(encoded));
    }
}