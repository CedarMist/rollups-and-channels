// SPDX-License-Identifier: CC-PDDC
pragma solidity ^0.8.0;

import {Sapphire} from "@oasisprotocol/sapphire-contracts/contracts/Sapphire.sol";

contract Counting {
    bytes32 private secret;

    constructor () {
        secret = randomBytes32();
    }

    function randomBytes32()
        internal view
        returns (bytes32)
    {
        return bytes32(Sapphire.randomBytes(32, ""));
    }

    function _encrypt(uint256 counter, bytes32 password)
        internal view
        returns (bytes32 nonce, bytes memory ciphertext)
    {
        nonce = randomBytes32();

        bytes memory plaintext = abi.encode(counter);

        ciphertext = Sapphire.encrypt(
            secret,
            nonce,
            plaintext,
            abi.encodePacked(password));
    }

    function _decrypt(bytes memory ciphertext, bytes32 nonce, bytes32 password)
        internal view
        returns (uint256 counter)
    {
        bytes memory plaintext = Sapphire.decrypt(
            secret,
            nonce,
            ciphertext,
            abi.encodePacked(password)
        );

        counter = abi.decode(plaintext, (uint256));
    }

    function startCount(bytes32 password)
        public view
        returns (bytes32 nonce, bytes memory ciphertext)
    {
        (nonce, ciphertext) = _encrypt(0, password);
    }

    function increment(
        bytes memory ciphertext,
        bytes32 nonce,
        bytes32 password
    )
        public view
        returns (bytes32, bytes memory)
    {
        uint256 counter = _decrypt(ciphertext, nonce, password);

        return _encrypt(counter + 1, password);
    }

    function reveal(bytes memory ciphertext, bytes32 nonce, bytes32 password)
        public view returns (bytes memory revealToken)
    {
        uint256 counter = _decrypt(ciphertext, nonce, password);

        require( counter != 0 );

        /*
        bytes32 revealAD = keccak256(abi.encodePacked(nonce, ciphertext));

        revealNonce = keccak256(abi.encodePacked(nonce, password));

        revealToken = Sapphire.encrypt(secret, revealNonce, abi.encode(password), abi.encodePacked(revealAD));

        return abi.encode(revealNonce, revealToken);
        */
    }

    function verifyReveal(bytes memory ciphertext, bytes memory revealToken)
        public view returns (uint256)
    {

    }
}