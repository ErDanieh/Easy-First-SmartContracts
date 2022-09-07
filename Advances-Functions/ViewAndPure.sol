pragma solidity ^0.8.0;

contract ViewAndPure {

    //Declare the state variable
    uint256 public x = 1;

    //Can read the state but not modify it
    function addToX(uint256 y) public view returns (uint256) {
        return x + y;
    }

    //Promise not to modify or read from state 
    function add(uint256 i, uint256 j) public pure returns (uint256) {
        return i + j;
    }
}
