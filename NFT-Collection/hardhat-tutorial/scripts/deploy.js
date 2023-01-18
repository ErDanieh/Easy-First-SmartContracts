const { ethers } = require("hardhat");
require("dotenv").config({ path: ".env" });
const { WHITELIST_CONTRACT_ADDRESS, METADATA_URL } = require("../constants");

async function main() {
  //Address al whitelist contract
  const whitelistContract = WHITELIST_CONTRACT_ADDRESS;

  //URL para la metadata
  const metadataURL = METADATA_URL;

  /*
    crear una instancia de un contrato inteligente denominado "CryptoDevs" en la blockchain Ethereum.
     La función getContractFactory permite crear una nueva instancia de un contrato inteligente existente
      a partir de su interfaz ABI (Application Binary Interface) y su dirección en la blockchain.
      En este caso, se está asignando la nueva instancia del contrato a la variable cryptoDevsContract.
  */
  const cryptoDevsContract = await ethers.getContractFactory("CryptoDevs");

  const deployedCryptoDevsContract = await cryptoDevsContract.deploy(
    metadataURL,
    whitelistContract
  );

  //Esperamos a que el contrato se despliegue
  await deployedCryptoDevsContract.deployed();

  console.log(
    "Address del contrato generador de NFTs",
    deployedCryptoDevsContract.address
  );
}

main().then(() => process.exit(0)).catch((error) => {
    console.error(error);
    process.exit(1);
})
