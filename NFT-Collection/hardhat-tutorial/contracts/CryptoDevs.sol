// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./IWhitelist.sol";

contract CryptoDevs is ERC721Enumerable, Ownable{

    /**
        Concatenacion de la base del url y el id de cada token
     */
    string _baseTokenURL;

    //Precio de cada NFT
    uint public _price = 0.01 ether;

    //Maximo numero de NFTs
    uint256 public maxTokenIds = 20;

    //cantidad de tokens creados;
    uint256 public tokenIds;

    //Whitelist contract instance;
    IWhitelist whitelist;

    //booleano para ver si la presale ha empezado o no
    bool public presaleStarted;

    //timestamp para ver cuando termina la presale
    uint256 public presaleEnded;

    //Pausada la venta
    bool public _paused;

    modifier onlyWhenNotPaused{
        require(!_paused, "Contrato pausado");
        _;
    }

    constructor (string memory baseURI, address whitelistContract) ERC721("Crypto Devs", "CD"){
        _baseTokenURL = baseURI;
        whitelist = IWhitelist(whitelistContract);
    }

    //La presale solo empiza para los whitelisted
    function startPresale() public onlyOwner{
        presaleStarted = true;

        presaleEnded = block.timestamp + 5 minutes;
    }

    //Permite al usuario solo minar un NFT por transaccion durante la presale
    function presaleMint() public payable onlyWhenNotPaused {
        require(presaleStarted && block.timestamp < presaleEnded, "Presale is not running");
        require(whitelist.whitelistedAddress(msg.sender), "You r not whitelisted");
        require(tokenIds < maxTokenIds, "No quedan NFT");
        require(msg.value >= _price, "Ether sent is not correct");

        tokenIds += 1;

        /**
         Si la dirección a la que se está acuñando no es un contrato, funciona de la misma manera que "_mint".
          La función se ejecuta con el remitente del mensaje como primer parámetro y una matriz de identificadores 
          de token como segundo parámetro. */
        _safeMint(msg.sender, tokenIds);
    }

    function mint() public payable onlyWhenNotPaused{
        require(presaleStarted && block.timestamp >= presaleEnded, "Presale is not running");
        require(whitelist.whitelistedAddress(msg.sender), "You r not whitelisted");
        require(tokenIds < maxTokenIds, "No quedan NFTs");
        require(msg.value >= _price, "Ether sent is not correct");
        tokenIds += 1;

        _safeMint(msg.sender, tokenIds);
    }

    //Sobreescribimos el metodo de base URI ya que por defecto devuelve una string vacia
    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURL;
    }

    //Funcion para poner en pausa la preventa
    function setPaused(bool value) public onlyOwner{
        _paused = value;
    }

    //funcion para retirar el ether almacenado en el contrato tras las ventas
    function withdraw() public onlyOwner {
        address _owner = owner();
        uint256 amount = address(this).balance;
        (bool sent,) = _owner.call{value: amount}("");
        require(sent, "Failed to send Ether");
    }

    //Funcion para recibir ether, msg.data tiene que estar vacio
    receive()external payable{}

    //Funcion para cuando msg.data no esta vacio
    fallback() external payable{}


}