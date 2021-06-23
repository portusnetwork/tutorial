// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

import "./IEndpointStore.sol";

interface IPortus is IEndpointStore {
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
    returns (bytes32 requestId);

    function fulfill(
        bytes32 requestId,
        bytes32 providerId,
        uint256 statusCode,
        bytes32 data,
        address responseContractAddress,
        bytes4 responseContractFunctionId
    )
    external
    returns(
        bool callSuccess,
        bytes memory callData
    );

    function fulfillWithBytes(
        bytes32 requestId,
        bytes32 providerId,
        uint256 statusCode,
        bytes calldata data,
        address responseContractAddress,
        bytes4 responseContractFunctionId
    )
    external
    returns(
        bool callSuccess,
        bytes memory callData
    );

    function fail(
        bytes32 requestId,
        bytes32 providerId,
        address responseContractAddress,
        bytes4 responseContractFunctionId
    )
    external;

    event ClientRequestFailed(
        bytes32 indexed providerId,
        bytes32 indexed requestId
    );

    event ClientRequestFulfilled(
        bytes32 indexed providerId,
        bytes32 indexed requestId,
        uint256 statusCode,
        bytes32 data
    );

    event ClientRequestFulfilledWithBytes(
        bytes32 indexed providerId,
        bytes32 indexed requestId,
        uint256 statusCode,
        bytes data
    );

    event ClientRequestCreated(
        bytes32 indexed providerId,
        bytes32 indexed requestId,
        uint256 noRequests,
        address clientAddress,
        bytes32 endpointId,
        uint256 consumerId,
        address apiWallet,
        address responseContractAddress,
        bytes4 responseContractFunctionId,
        bytes parameters
    );

    event EndpointUpdated(
        bytes32 indexed providerId,
        bytes32 indexed endpointId,
        address[] authorizers
    );

    event ProviderCreated(
        bytes32 indexed providerId,
        address admin,
        string xpub
    );

    event ProviderUpdated(
        bytes32 indexed providerId,
        address admin
    );

    event WithdrawalRequested(
        bytes32 indexed providerId,
        uint256 indexed consumerId,
        bytes32 indexed withdrawalRequestId,
        address apiWallet,
        address destination
    );

    event WithdrawalFulfilled(
        bytes32 indexed providerId,
        uint256 indexed consumerId,
        bytes32 indexed withdrawalRequestId,
        address apiWallet,
        address destination,
        uint256 amount
    );
}
