// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

import "./interfaces/IPortusClient.sol";
import "../protocol/interfaces/IPortus.sol";

/// @title The contract to be inherited from to use Portkey to make requests
contract PortusClient is IPortusClient {
    IPortus public protocol;

    /// @dev Portus protocol address is set at deployment. If you need to be able to
    /// update it, you will have to implement that functionality (and probably
    /// put it behind onlyOwner).
    /// @param protocolAddress Portus contract address
    constructor (address protocolAddress)
    public
    {
        protocol = IPortus(protocolAddress);
    }

    /// @notice Returns the protocol contract address used by this client
    /// @return _protocolAddress protocol contract address
    function protocolAddress()
    external
    view
    override
    returns(address _protocolAddress)
    {
        _protocolAddress = address(protocol);
    }

    /// @dev Reverts if the caller is not the Portus protocol contract
    /// Use it as a modifier for fulfill and error callback methods
    modifier onlyPortus()
    {
        require(
            msg.sender == address(protocol),
            "Caller not the Portus protocol contract"
        );
        _;
    }
}
