//// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./ICryptoDevs.sol";

contract CryptoDevToken is ERC20, Ownable {
    //Precio de un Token
    uint256 public constant tokenPrice = 0.001 ether;
    /** Cada NFT le daría al usuario 10 tokens
        Debe representarse como 10 * (10 ** 18) ya que los tokens ERC20 están representados por la denominación más pequeña posible para el token
       Por defecto, los tokens ERC20 tienen la denominación más pequeña de 10^(-18). Esto significa, tener un saldo de (1)
       es en realidad igual a (10 ^ -18) tokens.
       Poseer 1 token completo es equivalente a poseer (10^18) tokens cuando se tienen en cuenta los lugares decimales.
       Puede encontrar más información sobre esto en el tutorial Freshman Track Cryptocurrency.
       */
    uint256 public constant tokensPerNFT = 10 * 10**18;

    uint256 public constant maxTotalSuply = 10000 * 10**18;

    //Instancia del contrato
    ICryptoDevs CryptoDevsNFT;

    //Mapping de todos los tokens que han sido reclamados
    mapping(uint256 => bool) public tokenIdsClaimed;

    constructor(address _cryptoDevsContract) ERC20("Crypto Dev Token", "CD") {
        CryptoDevsNFT = ICryptoDevs(_cryptoDevsContract);
    }

    function mint(uint256 amount) public payable {
        //El valor del ether debe de ser igual o mayor que el precio del token * cantidad
        uint256 _requiredAmount = tokenPrice * amount;

        require(msg.value >= _requiredAmount, "No tienes suficiente ether");
        uint256 amountWithDecimals = amount * 10**18;
        require(
            (totalSupply() + amountWithDecimals) <= maxTotalSuply,
            "No quedan tokens"
        );
        _mint(msg.sender, amountWithDecimals);
    }
}
