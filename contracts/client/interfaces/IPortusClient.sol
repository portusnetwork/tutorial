// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

interface IPortusClient {
    function protocolAddress()
    external
    view
    returns (address _protocolAddress);
}
