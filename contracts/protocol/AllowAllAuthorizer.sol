// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

import "./interfaces/IAuthorizer.sol";
import "hardhat/console.sol";

contract AllowAllAuthorizer is IAuthorizer {
    function checkIfAuthorized(
        bytes32 requestId, // solhint-disable-line
        bytes32 providerId,
        bytes32 endpointId, // solhint-disable-line
        uint256 requesterIndex, // solhint-disable-line
        address designatedWallet,
        address clientAddress // solhint-disable-line
    )
    virtual
    external
    view
    override
    returns (bool status)
    {
        return true;
    }
}
