// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

import "./IConsumerStore.sol";

interface IProviderStore is IConsumerStore {
    function createProvider(
        address admin,
        string calldata xpub
    )
    external
    payable
    returns (bytes32 providerId);

    function updateProvider(
        bytes32 providerId,
        address admin
    )
    external;

    function requestWithdrawal(
        bytes32 providerId,
        uint256 consumerId,
        address designatedWallet,
        address destination
    )
    external;

    function approveWithdrawal(
        bytes32 withdrawalRequestId,
        bytes32 providerId,
        uint256 consumerId,
        address destination
    )
    external
    payable;

    function getProvider(bytes32 providerId)
    external
    view
    returns (
        address admin,
        string memory xpub
    );

    function getProviderAndBlockNumber(bytes32 providerId)
    external
    view
    returns (
        address admin,
        string memory xpub,
        uint256 blockNumber
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
        address designatedWallet,
        address destination
    );

    event WithdrawalFulfilled(
        bytes32 indexed providerId,
        uint256 indexed consumerId,
        bytes32 indexed withdrawalRequestId,
        address designatedWallet,
        address destination,
        uint256 amount
    );

    event StakingPoolCreated(
        bytes32 indexed providerId,
        uint256 poolId
    );

    event StakeCreated(
        bytes32 indexed providerId,
        uint256 indexed poolId,
        address sender,
        uint256 amount
    );

    event StakeRemoved(
        bytes32 indexed providerId,
        uint256 indexed poolId,
        address receiver,
        uint256 amount
    );
}
