pragma solidity ^0.8.7;

contract Modifiers {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    //Create a modifier that only allows a function to be called by the owner
    modifier OnlyOwner() {
        require(msg.sender == owner, "You are not the owner");
        // Underscore is a special character used inside modifiers
        // Which tells Solidity to execute the function the modifier is used on
        // at this point
        // Therefore, this modifier will first perform the above check
        // Then run the rest of the code
        _;
    }

    //This function can only be called by the owner
    function changeOwner(address _newOwner) public OnlyOwner {
        owner = _newOwner;
    }
}
