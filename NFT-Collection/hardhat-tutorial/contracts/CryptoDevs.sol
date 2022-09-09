pragma solidity ^0.8.0;

/**
Import de ERC721Enumerable standard from OpenZeppelin
this one is going to help us to track our NFTs
**/
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

/**
Import Ownable from OpenZeppelin
By default, the owner of an Ownable contract is the account that deployed it, which is usually exactly what you want.
transferOwnership from the owner account to a new one, and
renounceOwnership for the owner to relinquish this administrative privilege,
a common pattern after an initial stage with centralized administration is over.
 */
import "@openzeppelin/contracts/access/Ownable.sol";

//Import IWhitelist interface
import "./IWhitelist.sol";

contract CryptoDevs is ERC721Enumerable, Ownable {
    /**
    For computing {tokenURI}. If set, the result URI for each token will 
    be the concatenation of the base and the TokenId
     */
    string _baseTokenURI;

    //_price is the price of one Crypto Dev NFT
    uint256 public _price = 0.01 ether;

    //_paused is used to pause the contract in case of an emergency
    bool public _paused;

    //max number of CryptoDevs
    uint256 public maxTokenIds = 20;

    //Whitelist contract instance
    IWhitelist whitelist;

    //Booleand value for know if the presale has started or not
    bool public presaleStarted;

    // timestamp for when presale would end
    uint256 public presaleEnded;

    //Modifier for paused contract
    modifier OnlyWhenNotPauses() {
        require(!_paused, "Contract currently paused");
        _;
    }

    /**
     * @dev ERC721 constructor takes in a `name` and a `symbol` to the token collection.
     * name in our case is `Crypto Devs` and symbol is `CD`.
     * Constructor for Crypto Devs takes in the baseURI to set _baseTokenURI for the collection.
     * It also initializes an instance of whitelist interface.
     */
    constructor(string memory baseURI, address whitelistContract)
        ERC721("Crypto Devs", "CD")
    {
        _baseTokenURI = baseURI;
        whitelist = IWhitelist(whitelistContract);
    }
}
