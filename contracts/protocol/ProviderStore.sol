// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

import "./ConsumerStore.sol";
import "./interfaces/IProviderStore.sol";

contract ProviderStore is ConsumerStore, IProviderStore {
    mapping(bytes32 => Provider) internal providers;
    mapping(bytes32 => bytes32) private withdrawalRequestIdToParameters;
    uint256 private noWithdrawalRequests = 0;

    struct Provider {
        address admin;
        string publicKey;
    }

    function createProvider(
        address admin,
        string calldata publicKey
    )
    external payable override
    returns (bytes32 providerId)
    {
        providerId = keccak256(abi.encode(msg.sender));
        providers[providerId] = Provider({
        admin : admin,
        publicKey : publicKey
        });
        emit ProviderCreated(
            providerId,
            admin,
            publicKey
        );
        if (msg.value > 0)
        {
            (bool success,) = admin.call{value : msg.value}("");
            // solhint-disable-line
            require(success, "Transfer failed");
        }
    }

    function updateProvider(
        bytes32 providerId,
        address admin
    )
    external override onlyProviderAdmin(providerId)
    {
        providers[providerId].admin = admin;
        emit ProviderUpdated(
            providerId,
            admin
        );
    }

    function requestWithdrawal(
        bytes32 providerId,
        uint256 consumerId,
        address apiWallet,
        address destination
    )
    external override onlyConsumerAdmin(consumerId)
    {
        bytes32 withdrawalRequestId = keccak256(abi.encodePacked(
                this,
                noWithdrawalRequests++
            ));
        bytes32 withdrawalParameters = keccak256(abi.encodePacked(
                providerId,
                consumerId,
                apiWallet,
                destination
            ));
        withdrawalRequestIdToParameters[withdrawalRequestId] = withdrawalParameters;
        emit WithdrawalRequested(
            providerId,
            consumerId,
            withdrawalRequestId,
            apiWallet,
            destination
        );
    }

    function approveWithdrawal(
        bytes32 withdrawalRequestId,
        bytes32 providerId,
        uint256 consumerId,
        address destination
    )
    external payable override
    {
        bytes32 withdrawalParameters = keccak256(abi.encodePacked(
                providerId,
                consumerId,
                msg.sender,
                destination
            ));
        require(
            withdrawalRequestIdToParameters[withdrawalRequestId] == withdrawalParameters,
            "No such withdrawal request"
        );
        delete withdrawalRequestIdToParameters[withdrawalRequestId];
        emit WithdrawalFulfilled(
            providerId,
            consumerId,
            withdrawalRequestId,
            msg.sender,
            destination,
            msg.value
        );
        (bool success,) = destination.call{value : msg.value}("");
        // solhint-disable-line
        require(success, "Transfer failed");
    }

    function getProvider(bytes32 providerId)
    external view override
    returns (address admin, string memory publicKey)
    {
        admin = providers[providerId].admin;
        publicKey = providers[providerId].publicKey;
    }

    function getProviderAndBlockNumber(bytes32 providerId)
    external view override
    returns (address admin, string memory xpub, uint256 blockNumber)
    {
        (admin, xpub) = this.getProvider(providerId);
        blockNumber = block.number;
    }

    modifier onlyProviderAdmin(bytes32 providerId)
    {
        require(
            msg.sender == providers[providerId].admin,
            "NOT_PROVIDER_ADMIN"
        );
        _;
    }
}
