pragma solidity ^0.8.0;

contract Whitelist {
    //Max number of whitelisted addresses allowed
    uint256 public maxWhitelistedAddresses;

    //Create a mapping of whitelistedaddresses
    mapping(address => bool) public whitelistedAddresses;

    // numAddressesWhitelisted would be used to keep track of how many addresses have been whitelisted
    uint8 public numAddressesWhitelisted;

    //The user can change the limitation number at the time of deployment
    constructor(uint8 _maxWhitelistedAddresses) {
        maxWhitelistedAddresses = _maxWhitelistedAddresses;
    }

    //This function add users to the whitelist

    function addAddressToWhitelist() public {
        //Check if the address is already whitelisted
        require(
            !whitelistedAddresses[msg.sender],
            "Sender has already been whitelisted"
        );

        //Check max number of address is reached
        require(
            numAddressesWhitelisted < maxWhitelistedAddresses,
            "Whitelist is full"
        );

        //Add the new address to the whitelist
        whitelistedAddresses[msg.sender] = true;

        //Increase the number of whitelisted addresses
        numAddressesWhitelisted += 1;
    }
}
