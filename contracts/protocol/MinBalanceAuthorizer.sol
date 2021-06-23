// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

import "./interfaces/IMinBalanceAuthorizer.sol";
import "./interfaces/IPortus.sol";

contract MinBalanceAuthorizer is IMinBalanceAuthorizer {
    IPortus public protocol;
    uint256 public immutable authorizerType = 1;
    mapping(bytes32 => uint256) private providerIdToMinBalance;

    /// @param _protocol Address of the Portus protocol contract
    constructor (address _protocol)
    public
    {
        protocol = IPortus(_protocol);
    }

    function updateMinBalance(
        bytes32 providerId,
        uint256 minBalance
    )
    external
    override
    {
        (address admin, string memory xpub) = protocol.getProvider(providerId);  // solhint-disable-line
        require(msg.sender == admin, "NOT_PROVIDER_ADMIN");
        providerIdToMinBalance[providerId] = minBalance;
        emit MinBalanceUpdated(providerId, minBalance);
    }

    function checkIfAuthorized(
        bytes32 requestId,    // solhint-disable-line
        bytes32 providerId,
        bytes32 endpointId,   // solhint-disable-line
        uint256 consumerId, // solhint-disable-line
        address apiWallet,
        address clientAddress // solhint-disable-line
    )
    virtual
    external
    view
    override
    returns (bool status)
    {
        return apiWallet.balance >= providerIdToMinBalance[providerId];
    }
}
