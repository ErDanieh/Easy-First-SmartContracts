//// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

interface ICryptoDevs {
    //La función "tokenOfOwnerByIndex" toma dos argumentos: una dirección de Ethereum que representa el
    //propietario, y un índice (uint256). Esta función devuelve un token ID que es propiedad del propietario en el índice dado de su lista de tokens.
    function tokenOfOwnerByIndex(address owner, uint256 index)
        external
        view
        returns (uint256 tokenId);

    //La función "balanceOf" toma una dirección de Ethereum que representa el propietario, y devuelve el número de tokens en la cuenta del propietario.
    function balanceOf(address owner) external view returns (uint256 balance);
}
