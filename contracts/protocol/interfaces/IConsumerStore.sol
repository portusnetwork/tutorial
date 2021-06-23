// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

interface IConsumerStore {
    function createConsumer(address adminAddress)
    external
    returns (uint256 consumerId);

    function updateConsumerAdmin(
        uint256 consumerId,
        address adminAddress
    )
    external;

    function updateConsumerClientContract(
        uint256 consumerId,
        address contractAddress,
        bool enabled
    )
    external;

    event ConsumerCreated(
        uint256 indexed consumerId,
        address adminAddress
    );

    event ConsumerUpdated(
        uint256 indexed consumerId,
        address adminAddress
    );

    event ClientContractStatusUpdated(
        uint256 indexed requesterIndex,
        address indexed clientAddress,
        bool endorsementStatus
    );
}
