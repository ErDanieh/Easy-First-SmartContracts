//// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

//Expone funciones basicas que tendria una DAO para comprar nfts
contract FakeNFTMarketplace {
    /**
    Este código crea un mapeo público en el contrato inteligente llamado "tokens" 
    que asocia un uint256 (entero sin signo de 256 bits) con una dirección. Este mapeo
    se utiliza para asociar un "Fake TokenID" (identificador de ficha falso) con una
    dirección "Propietario". La etiqueta "dev" indica que esta es una documentación 
    de desarrollador y no está destinada para uso general. Este mapeo se puede utilizar
    para llevar un registro de qué dirección es propietaria de qué ficha. */
    mapping(uint256 => address) public tokens;

    uint256 nftPrice = 0.1 ether;

    //Acepta el ether y asigna el tokenid a la llamador
    function purchase(uint256 _tokenId) external payable {
        require(msg.value == nftPrice, "This Nft cost 0.1 ether");
        tokens[_tokenId] = msg.sender;
    }

    //Devuelve el precio de un nft
    function getPrice() external view returns (uint256) {
        return nftPrice;
    }

    //Mira si un tokenId esta libre o no mirando si no tiene una cartera asignada
    function available(uint256 _tokenId) external view returns (bool) {
        // address(0) = 0x0000000000000000000000000000000000000000
        if (tokens[_tokenId] == address(0)) {
            return true;
        }
        return false;
    }


}
