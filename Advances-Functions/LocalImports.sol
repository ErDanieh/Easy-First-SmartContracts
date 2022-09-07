pragma solidity ^0.8.7;

//import Foo.sol from current directory
import "./Foo.sol";

//For external imports
// https://github.com/owner/repo/blob/branch/path/to/Contract.sol
import "https://github.com/owner/repo/blob/branch/path/to/Contract.sol";

// Example import ERC20.sol from openzeppelin-contract repo
// https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";

contract Import {
    Foo public foo = new Foo();

    //Test Foo.sol by getting its name
    function getFooName() public view returns (string memory) {
        return foo.name();
    }
}
