// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

import "./PortusClient.sol";
import "hardhat/console.sol";

contract ExampleClient is PortusClient {
    mapping(bytes32 => bool) private incomingResponses;

    constructor (address protocolAddress) public PortusClient(protocolAddress) {
    }

    function makeRequestInt256(
        bytes32 providerId,
        bytes32 endpointId,
        uint256 consumerId,
        address apiWallet,
        bytes calldata parameters
    )
    external
    {
        bytes32 requestId = protocol.submitRequest(
            providerId,
            endpointId,
            consumerId,
            apiWallet,
            address(this),
            this.receiveResponseInt256.selector,
            parameters
        );
        incomingResponses[requestId] = true;
    }

    function makeRequestUint256(
        bytes32 providerId,
        bytes32 endpointId,
        uint256 consumerId,
        address apiWallet,
        bytes calldata parameters
    )
    external
    {
        bytes32 requestId = protocol.submitRequest(
            providerId,
            endpointId,
            consumerId,
            apiWallet,
            address(this),
            this.receiveResponseUint256.selector,
            parameters
        );
        incomingResponses[requestId] = true;
    }

    function makeRequestBool(
        bytes32 providerId,
        bytes32 endpointId,
        uint256 consumerId,
        address designatedWallet,
        bytes calldata parameters
    )
    external
    {
        bytes32 requestId = protocol.submitRequest(
            providerId,
            endpointId,
            consumerId,
            designatedWallet,
            address(this),
            this.receiveResponseBool.selector,
            parameters
        );
        incomingResponses[requestId] = true;
    }

    function makeRequestString(
        bytes32 providerId,
        bytes32 endpointId,
        uint256 consumerId,
        address designatedWallet,
        bytes calldata parameters
    )
    external
    {
        bytes32 requestId = protocol.submitRequest(
            providerId,
            endpointId,
            consumerId,
            designatedWallet,
            address(this),
            this.receiveResponseString.selector,
            parameters
        );
        incomingResponses[requestId] = true;
    }

    function makeRequestBytes(
        bytes32 providerId,
        bytes32 endpointId,
        uint256 consumerId,
        address designatedWallet,
        bytes calldata parameters
    )
    external
    {
        bytes32 requestId = protocol.submitRequest(
            providerId,
            endpointId,
            consumerId,
            designatedWallet,
            address(this),
            this.receiveResponseBytes.selector,
            parameters
        );
        incomingResponses[requestId] = true;
    }

    function receiveResponseInt256(
        bytes32 requestId,
        uint256 statusCode,
        int256 data
    )
    external onlyPortus()
    {
        require(incomingResponses[requestId], "No such request made");
        delete incomingResponses[requestId];

        console.log("##### fulfillInt256() #####");
        console.logInt(data);
    }

    function receiveResponseUint256(
        bytes32 requestId,
        uint256 statusCode,
        uint256 data
    )
    external onlyPortus()
    {
        require(incomingResponses[requestId], "No such request made");
        delete incomingResponses[requestId];

        console.log("##### fulfillUint256() #####");
        console.logUint(data);
    }

    function receiveResponseBool(
        bytes32 requestId,
        uint256 statusCode,
        bool data
    )
    external onlyPortus()
    {
        require(incomingResponses[requestId], "No such request made");
        delete incomingResponses[requestId];

        console.log("##### fulfillBool() #####");
        console.logBool(data);
    }

    function receiveResponseString(
        bytes32 requestId,
        uint256 statusCode,
        string calldata data
    )
    external onlyPortus()
    {
        require(incomingResponses[requestId], "No such request made");
        delete incomingResponses[requestId];

        console.log("##### fulfillString() #####");
        console.log(data);
    }

    function receiveResponseBytes(
        bytes32 requestId,
        uint256 statusCode,
        bytes calldata data
    )
    external onlyPortus()
    {
        require(incomingResponses[requestId], "No such request made");
        delete incomingResponses[requestId];

        console.log("##### fulfillBytes() #####");
        console.logBytes(data);
    }
}
