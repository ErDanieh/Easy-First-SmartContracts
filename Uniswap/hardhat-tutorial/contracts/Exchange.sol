//// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Exchange is ERC20 {
    address public cryptoDevTokenAddress;

    //Mantendra el trackeo de todos los Crypto Dev LP tokens
    constructor(address _CryptoDevtoken) ERC20("CryptoDevToken", "CDLP") {
        require(_CryptoDevtoken != address(0), "Invalid address");
        cryptoDevTokenAddress = _CryptoDevtoken;
    }

    //devuelve la cantidad de tokens que tiene el contrato
    function getReserve() public view returns (uint256) {
        return ERC20(cryptoDevTokenAddress).balanceOf(address(this));
    }

    /**
     * If cryptoDevTokenReserve is zero it means that it is the first time someone
     *  is adding Crypto Dev tokens and ETH to the contract. In this case, we don't
     * have to maintain a ratio between the tokens as we don't have any liquidity.
     *  So we accept any amount of tokens that user has sent with the initial call.
     */
    //(cryptoDevTokenAmount user can add/cryptoDevTokenReserve in the contract) = (Eth Sent by the user/Eth Reserve in the contract)
    function addLiquidity(uint256 _amount) public payable returns (uint256) {
        uint256 liquidity;
        uint256 ethBalance = address(this).balance;
        uint256 cryptoDevTokenReserve = getReserve();
        ERC20 cryptoDevToken = ERC20(cryptoDevTokenAddress);

        if (cryptoDevTokenReserve == 0) {
            // Transfer the `cryptoDevToken` from the user's account to the contract
            cryptoDevToken.transferFrom(msg.sender, address(this), _amount);
            liquidity = ethBalance;
            // _mint is ERC20.sol smart contract function to mint ERC20 tokens
            _mint(msg.sender, liquidity);
        } else {
            uint256 ethReserve = ethBalance - msg.value;
            uint256 cryptoDevTokenAmount = (msg.value * cryptoDevTokenReserve) /
                (ethReserve);

            require(
                _amount >= cryptoDevTokenAmount,
                "La cantidad de tokens de requerida es menor a al enviada"
            );

            cryptoDevToken.transferFrom(
                msg.sender,
                address(this),
                cryptoDevTokenAmount
            );

            liquidity = (totalSupply() * msg.value) / ethReserve;

            _mint(msg.sender, liquidity);
        }
        return liquidity;
    }

    //Funcion para quitar la liquidez del contrato
    function removeLiquidity(uint256 _amount)
        public
        returns (uint256, uint256)
    {
        require(_amount > 0, "La cantidad debe ser mayor de 0");
        uint256 ethReserve = address(this).balance;
        uint256 _totalSupply = totalSupply();

        uint256 ethAmount = (ethReserve * _amount) / _totalSupply;

        uint256 cryptoDevTokenAmount = ((getReserve() * _amount) /
            _totalSupply);

        _burn(msg.sender, _amount);

        payable(msg.sender).transfer(ethAmount);

        ERC20(cryptoDevTokenAddress).transfer(msg.sender, cryptoDevTokenAmount);

        return (ethAmount, cryptoDevTokenAmount);
    }

    function getAmountOfTokens(
        uint256 inputAmount,
        uint256 inputReserve,
        uint256 outputReserve
    ) public pure returns (uint256) {
        require(inputReserve > 0 && outputReserve > 0, "invalid reserve");

        uint256 inputAmountWithFee = inputAmount * 99;

        uint256 numerator = inputAmountWithFee * outputReserve;

        uint256 denominator = (inputReserve * 100) + inputAmountWithFee;

        return numerator / denominator;
    }

    function ethToCryptoDevToken(uint256 _minTokens) public payable {
        uint256 tokenReserve = getReserve();

        uint256 tokensBought = getAmountOfTokens(
            msg.value,
            address(this).balance - msg.value,
            tokenReserve
        );

        require(tokensBought >= _minTokens, "valor de salidad insuficiente");

        ERC20(cryptoDevTokenAddress).transfer(msg.sender, tokensBought);
    }

    function cryptoDevTokenToEth(uint256 _tokensSold, uint256 _minEth) public {
        uint256 tokenReserve = getReserve();

        uint256 ethBought = getAmountOfTokens(
            _tokensSold,
            tokenReserve,
            address(this).balance
        );

        require(ethBought > _minEth, "Cantidad de salida insuficiente");

        ERC20(cryptoDevTokenAddress).transferFrom(
            msg.sender,
            address(this),
            _tokensSold
        );

        payable(msg.sender).transfer(ethBought);
    }
}
