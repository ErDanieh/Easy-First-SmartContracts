//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

contract Whitelist{
    uint8 public maxWhitelistedAddress;

    mapping(address => bool) public whitelistedAddress;

    uint8 public numAddressesWhitelisted;

    constructor(uint8 _maxWhitelistedAddresses){
        maxWhitelistedAddress = _maxWhitelistedAddresses;
    }

    function addAddressToWhitelist() public {
         require(!whitelistedAddress[msg.sender], "El usuario ya esta en la whitelist");
        require(numAddressesWhitelisted < maxWhitelistedAddress, "Limite alcanzado");

        whitelistedAddress[msg.sender] = true;

        numAddressesWhitelisted += 1;
    }

}