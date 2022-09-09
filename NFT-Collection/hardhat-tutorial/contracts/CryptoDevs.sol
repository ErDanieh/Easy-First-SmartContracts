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

    // total number of tokenIds minted
    uint256 public tokenIds;

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

    //Function for start the presale
    function startPresale() public onlyOwner {
        presaleStarted = true;
        //set presaleEnded time as current timestamp + 5 minutes

        presaleEnded = block.timestamp + 5;
    }

    /**
    Allow users to mint one NFT per transaction during the presale
     */
    function presaleMint() public payable onlyWhenNotPaused {
        //Comprobe that the presale has started and is not ended
        require(
            presaleStarted && block.timestamp < presaleEnded,
            "Presale is not running"
        );

        //Comprobe that addresses of the user is whitelisted
        require(
            whitelist.whitelistedAddresses(msg.sender),
            "You are not whitelisted"
        );
        //Comprobe that the user has enought ether
        require(msg.value >= _price, "Ether sent is not correct");

        tokenIds += 1;
        _safeMint(msg.sender, tokendIds);
    }

    //Mint all the tokens
    function mint() public payable onlyWhenNotPaused {
        require(
            presaleStarted && block.timestamp >= presaleEnded,
            "Presale has not ended yet"
        );
        require(tokenIds < maxTokenIds, "Exceed maximum Crypto Devs supply");
        require(msg.value >= _price, "Ether sent is not correct");

        tokenIds += 1;
        _safeMint(msg.sender, tokenIds);
    }

    /**
     * @dev _baseURI overides the Openzeppelin's ERC721 implementation which by default
     * returned an empty string for the baseURI
     */
    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }

    //Makes the contract paused or un paused
    function setPaused(bool val) public onlyOwner {
        _paused = val;
    }

    /**
        Withdraw sends all the ether in the contract to the owner of the contract
     */
    function withdraw() public onlyOwner {
        address _owner = owner();
        uint256 amount = address(this).balance;
        (bool sent, ) = _owner.call{value: amount}("");
        require(sent, "Failed to send the ether");
    }

    // Function to receive Ether. msg.data must be empty
    receive() external payable {}

    // Fallback function is called when msg.data is not empty
    fallback() external payable {}
}
