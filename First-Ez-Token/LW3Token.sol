//Choose the compiler standart
pragma solidity ^0.8.0;

//Import the standart rule from github this one is for Non Fungible Tokens
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";

contract LW3Token is ERC20{

    //Arguments _name contains something like -> Ethereum, _symbol contains something like -> ETH
    constructor(string memory _name, string memory _symbol) ERC20 (_name, _symbol){
        //Mint function specifies that users can't call this function
        //msg.sender direction to mint (acuñar)
        //10*10**18 cuantity of minted tokens ->10 tokens
        _mint(msg.sender, 10*10 ** 18);
    }
}