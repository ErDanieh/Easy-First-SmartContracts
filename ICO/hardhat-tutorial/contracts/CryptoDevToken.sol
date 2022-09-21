pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./ICryptoDevs.sol";

contract CryptoDevToken is ERC20, Ownable {
    uint256 public constant tokenPrice = 0.001 ether;

    uint256 public constant tokenPerNFT = 10 * 10**18;

    uint256 public constant maxTotalSupply = 10000 * 10**18;

    IcryptoDevs CryptoDevsNFT;

    //Mapping to keep track of the NFTs that have been claimed
    mapping(uint256 => bool) public tokenIdsClaimed;

    constructor(address _cryptoDevsContract) ERC20("Crypto Dev Token", "CD") {
        CryptoDevsNFT = IcryptoDevs(_cryptoDevsContract);
    }

    function mint() public payable {
        unint256 _requiredAmount = tokenPrice * amount;
        require(msg.value >= _requiredAmount, "Not enough ETH sent");

        uint256 amountWithDecimals = amount * 10**18;

        require(
            (totalSupply() + amountWithDecimals) <= maxTotalSupply,
            "Max supply reached"
        );

        _mint(msg.sender, amountWithDecimals);
    }
}
