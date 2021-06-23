// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity 0.6.12;

import "./EndpointStore.sol";
import "./interfaces/IPortus.sol";

/// @title The contract used by customers to make API requests
contract Portus is EndpointStore, IPortus {
    mapping(bytes32 => bytes32) private requestIdToResponseParameters;
    mapping(bytes32 => bool) public requestWithIdHasFailed;
    uint256 private noRequests = 0;

    /// @notice Called by the requester to make an API request.
    /// @param providerId Provider ID from ProviderStore
    /// @param endpointId Endpoint ID from EndpointStore
    /// @param consumerId Requester index from ConsumerStore
    /// @param apiWallet Designated wallet that is requested to fulfill the request
    /// @param responseContractAddress Address that will be called to fulfill
    /// @param responseContractFunctionId Signature of the function that will be called to fulfill
    /// @param parameters All request parameters
    /// @return requestId Request ID
    function submitRequest(
        bytes32 providerId,
        bytes32 endpointId,
        uint256 consumerId,
        address apiWallet,
        address responseContractAddress,
        bytes4 responseContractFunctionId,
        bytes calldata parameters
    )
    external
    override
    returns (bytes32 requestId)
    {
        require(
            consumerIdToClientAddressEnabled[consumerId][msg.sender],
            "CONTRACT_NOT_AUTHORIZED"
        );
        requestId = keccak256(abi.encode(
                noRequests,
                providerId,
                endpointId,
                parameters
            ));
        requestIdToResponseParameters[requestId] = keccak256(abi.encodePacked(
                providerId,
                apiWallet,
                responseContractAddress,
                responseContractFunctionId
            ));
        emit ClientRequestCreated(
            providerId,
            requestId,
            noRequests,
            msg.sender,
            endpointId,
            consumerId,
            apiWallet,
            responseContractAddress,
            responseContractFunctionId,
            parameters
        );
        noRequests++;
    }

    /// @notice Called by the oracle node to fulfill individual requests
    /// @param requestId Request ID
    /// @param providerId Provider ID from ProviderStore
    /// @param statusCode Status code of the fulfillment
    /// @param data Fulfillment data
    /// @param responseContractAddress Address that will be called to fulfill
    /// @param responseContractFunctionId Signature of the function that will be called to fulfill
    /// @return callSuccess If the fulfillment call succeeded
    /// @return callData Data returned by the fulfillment call (if any)
    function fulfill(
        bytes32 requestId,
        bytes32 providerId,
        uint256 statusCode,
        bytes32 data,
        address responseContractAddress,
        bytes4 responseContractFunctionId
    )
    external
    override
    onlyCorrectFulfillParameters(
        requestId,
        providerId,
        responseContractAddress,
        responseContractFunctionId
    )
    returns (
        bool callSuccess,
        bytes memory callData
    )
    {
        delete requestIdToResponseParameters[requestId];
        emit ClientRequestFulfilled(
            providerId,
            requestId,
            statusCode,
            data
        );
        (callSuccess, callData) = responseContractAddress.call(// solhint-disable-line
            abi.encodeWithSelector(responseContractFunctionId, requestId, statusCode, data)
        );
    }

    /// @notice Called by the oracle node to fulfill individual requests with a bytes type response
    /// @dev The oracle uses this method to fulfill if the requester has specifically asked for a bytes type response
    /// @param requestId Request ID
    /// @param providerId Provider ID from ProviderStore
    /// @param statusCode Status code of the fulfillment
    /// @param data Fulfillment data of type bytes
    /// @param responseContractAddress Address that will be called to fulfill
    /// @param responseContractFunctionId Signature of the function that will be called to fulfill
    /// @return callSuccess If the fulfillment call succeeded
    /// @return callData Data returned by the fulfillment call (if any)
    function fulfillWithBytes(
        bytes32 requestId,
        bytes32 providerId,
        uint256 statusCode,
        bytes calldata data,
        address responseContractAddress,
        bytes4 responseContractFunctionId
    )
    external
    override
    onlyCorrectFulfillParameters(
        requestId,
        providerId,
        responseContractAddress,
        responseContractFunctionId
    )
    returns (
        bool callSuccess,
        bytes memory callData
    )
    {
        delete requestIdToResponseParameters[requestId];
        emit ClientRequestFulfilledWithBytes(
            providerId,
            requestId,
            statusCode,
            data
        );
        (callSuccess, callData) = responseContractAddress.call(// solhint-disable-line
            abi.encodeWithSelector(responseContractFunctionId, requestId, statusCode, data)
        );
    }

    /// @notice Called by the oracle node if a request cannot be fulfilled
    /// @dev The oracle should fall back to this if a request cannot be fulfilled because fulfill() reverts
    /// @param requestId Request ID
    /// @param providerId Provider ID from ProviderStore
    /// @param responseContractAddress Address that will be called to fulfill
    /// @param responseContractFunctionId Signature of the function that will be called to fulfill
    function fail(
        bytes32 requestId,
        bytes32 providerId,
        address responseContractAddress,
        bytes4 responseContractFunctionId
    )
    external
    override
    onlyCorrectFulfillParameters(
        requestId,
        providerId,
        responseContractAddress,
        responseContractFunctionId
    )
    {
        delete requestIdToResponseParameters[requestId];
        // Failure is recorded so that it can be checked externally
        requestWithIdHasFailed[requestId] = true;
        emit ClientRequestFailed(
            providerId,
            requestId
        );
    }

    /// @dev Reverts unless the incoming fulfillment parameters do not match the ones provided in the request
    /// @param requestId Request ID
    /// @param providerId Provider ID from ProviderStore
    /// @param responseContractAddress Address that will be called to fulfill
    /// @param responseContractFunctionId Signature of the function that will be called to fulfill
    modifier onlyCorrectFulfillParameters(
        bytes32 requestId,
        bytes32 providerId,
        address responseContractAddress,
        bytes4 responseContractFunctionId
    )
    {
        bytes32 incomingResponseParameters = keccak256(abi.encodePacked(
                providerId,
                msg.sender,
                responseContractAddress,
                responseContractFunctionId
            ));
        require(
            incomingResponseParameters == requestIdToResponseParameters[requestId],
            "INVALID_FULFILL_PARAMETERS"
        );
        _;
    }
}

