//Assume there is an external ERC20 contract, and we are interested
//in calling the balanceOf function to check the balance of a given
//address from our contract.

pragma solidity ^0.8.7;

interface MinimalERC20 {
    function balanceOf(address account) external view returns (uint256);
}

contract MyContract {
    MinimalERC20 externalContract;

    constructor(address _externalContract) {
        // Initialize a MinimalERC20 contract instance
        externalContract = MinimalERC20(_externalContract);
    }

    function mustHavesSomeBalance() public {
        // Require that the caller of this transaction has a non-zero
        // balance of tokens in the external ERC20 contract
        uint256 balance = externalContract.balanceOf(msg.sender);
        require(balance > 0, "You dont have any tokens of external contract");
    }
}
