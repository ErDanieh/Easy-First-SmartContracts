const { ethers } = require("hardhat");

async function main() {
  //Create the contractFactory for deploy new smart contracts
  const whitelistContract = await ethers.getContractFactory("Whitelist");

  //Deploy the contract -> 10 is the param to set the maxium number of whitelisted adresses
  const deployedWhitelistContract = await whitelistContract.deploy(10);
  //Whaiting for the deploy
  await deployedWhitelistContract.deployed();

  //print the address of the sc
  console.log("Whitelist Contract Address:", deployedWhitelistContract.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.log(error);
    process.exit(1);
  });
