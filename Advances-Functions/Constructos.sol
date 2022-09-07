pragma solidity ^0.8.7;

contract X {
    string public name;

    constructor(string memory _name) {
        //This will be set immediately when the contract is deployed
        name = _name;
    }
}
