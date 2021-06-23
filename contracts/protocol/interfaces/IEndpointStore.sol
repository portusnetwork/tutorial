// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

import "./IProviderStore.sol";

interface IEndpointStore is IProviderStore {
    function updateEndpointAuthorizers(
        bytes32 providerId,
        bytes32 endpointId,
        address[] calldata authorizers
    )
    external;

    function updateEndpointsAuthorizers(
        bytes32 providerId,
        bytes32[] calldata endpointIds,
        address[] calldata authorizers
    )
    external;

    function getEndpointAuthorizers(
        bytes32 providerId,
        bytes32 endpointId
    )
    external
    view
    returns (address[] memory authorizers);

    function checkAuthorizationStatus(
        bytes32 providerId,
        bytes32 requestId,
        bytes32 endpointId,
        uint256 requesterIndex,
        address designatedWallet,
        address clientAddress
    )
    external
    view
    returns(bool status);

    function checkAuthorizationStatuses(
        bytes32 providerId,
        bytes32[] calldata requestIds,
        bytes32[] calldata endpointIds,
        uint256[] calldata requesterIndices,
        address[] calldata designatedWallets,
        address[] calldata clientAddresses
    )
    external
    view
    returns (bool[] memory statuses);

    event EndpointUpdated(
        bytes32 indexed providerId,
        bytes32 indexed endpointId,
        address[] authorizers
    );

    event EndpointsUpdated(
        bytes32 indexed providerId,
        bytes32[] indexed endpointIds,
        address[] authorizers
    );
}
