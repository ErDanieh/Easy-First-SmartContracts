pragma solidity ^0.8.0;

//Import the standart smartcontract token builder
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";


contract GameItem is ERC721 {
    //We mint only 1 nft
    constructor ()ERC721("GameItem","ITM"){
        _mint(msg.sender, 1);
    }
}