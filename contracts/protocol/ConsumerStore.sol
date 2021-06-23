// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

import "./interfaces/IConsumerStore.sol";

contract ConsumerStore is IConsumerStore {
    mapping(uint256 => address) public consumerAdmins;
    mapping(uint256 => mapping(address => bool)) public consumerIdToClientAddressEnabled;
    uint256 private noConsumers = 1;

    function createConsumer(address adminAddress)
    external override
    returns (uint256 consumerId)
    {
        consumerId = noConsumers++;
        consumerAdmins[consumerId] = adminAddress;
        emit ConsumerCreated(
            consumerId,
            adminAddress
        );
    }

    function updateConsumerAdmin(
        uint256 consumerId,
        address adminAddress
    )
    external override
    onlyConsumerAdmin(consumerId)
    {
        consumerAdmins[consumerId] = adminAddress;
        emit ConsumerUpdated(
            consumerId,
            adminAddress
        );
    }

    function updateConsumerClientContract(
        uint256 consumerId,
        address contractAddress,
        bool enabled
    )
    external override
    onlyConsumerAdmin(consumerId)
    {
        consumerIdToClientAddressEnabled[consumerId][contractAddress] = enabled;
        emit ClientContractStatusUpdated(
            consumerId,
            contractAddress,
            enabled
        );
    }

    /// @dev Reverts if the caller is not the requester admin
    /// @param consumerId Consumer index
    modifier onlyConsumerAdmin(uint256 consumerId)
    {
        require(
            msg.sender == consumerAdmins[consumerId],
            "NOT_CONSUMER_ADMIN"
        );
        _;
    }
}
