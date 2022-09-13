import { Contrac, providers, utils } from "ethers";
import Head from "next/head";
import React, { useEffect, useRef, useState } from "react";
import Web3Modal from "web3Modal";
import { abi, NFT_CONTRACT_ADDRESS } from "../constants/index.js";
import styles from "../styles/Home.module.css";

export default function Home() {
  //Keep track of wheter the user's wallet is connected or not
  const [walletConnected, setWalletConnected] = useState(false);

  //keep the track of wheter the presale has started or not
  const [presaleStarted, setPresaleStarted] = useState(false);

  //Keeps the track of wheter the presale ended
  const [presaleEnded, setPresaleEnded] = useState(false);

  //Loading is set true when the transaction is being mined
  const [loading, setLoading] = useState(false);

  //Check if the current metaMask wallet connected is the owner of the contract
  const [isOwner, setIsOwner] = useState(false);

  //Keeps the track of the number of tokenids that have been minted
  const [tokenIdsMinted, setTokenIdsMinted] = useState("0");

  // Create a reference to the Web3 Modal (used for connecting to Metamask) which persists as long as the page is open
  const web3ModalRef = useRef();

  const presaleMint = async () => {
    try {
      const signer = await getProviderOrSigner(true);

      //Create a new instance of the contract with a signer, which allows
      //update methods
      const nftContract = new Contract(NFT_CONTRACT_ADDRESS, abi, signer);

      //call the presaleMint from the contract, only whitelisted addresses would be able to mint
      const tx = await nftContract.presaleMint({
        // value signifies the cost of one crypto dev which is "0.01" eth.
        // We are parsing `0.01` string to ether using the utils library from ethers.js
        value: utils.parseEther("0.01"),
      });

      setLoading(true);
      //Wait for the transaction to get mined
      await tx.wait();
      setLoading(false);

      window.alert("You succesfully minted a Crypto Dev");
    } catch (error) {
      console.log(error);
    }
  };

  const publicMint = async () => {
    try {
      //New signer instance
      const signer = await getProviderOrSigner(true);
      //New contract instance
      const nftContract = new Contract(NFT_CONTRACT_ADDRESS, abi, signer);

      //Call mint from the contract to mint the Crypto Dev
      const tx = await nftContract.mint({
        value: utils.parseEther("0.01"),
      });

      setLoading(true);
      //Wait for the transaction to get mined
      await tx.wait();
      setLoading(false);
      window.alert("You succesfully minted a Crypto Dev");
    } catch (error) {
      console.log(error);
    }
  };

  //ConnectWallet: connect to metamask wallet
  const connectWallet = async () => {
    try {
      await getProviderOrSigner();
      setWalletConnected(true);
    } catch (error) {
      console.log(error);
    }
  };

  const startPresale = async () => {
    try {
      const signer = await getProviderOrSigner();

      const nftContract = new Contract(NFT_CONTRACT_ADDRESS, abi, signer);

      //Call the startPresale from contract
      const tx = await nftContract.startPresale();
      setLoading(true);
      await tx.wait();
      setLoading(false);

      await checkIfPresaleStarted();
    } catch (error) {
      console.log(error);
    }
  };

  const checkIfPresaleStarted = async () => {
    try {
      // Get the provider from web3Modal, which in our case is MetaMask
      // No need for the Signer here, as we are only reading state from the blockchain
      const provider = await getProviderOrSigner();
      // We connect to the Contract using a Provider, so we will only
      // have read-only access to the Contract
      const nftContract = new Contract(NFT_CONTRACT_ADDRESS, abi, provider);
      // call the presaleStarted from the contract
      const _presaleStarted = await nftContract.presaleStarted();

      if (!_presaleStarted) {
        await getOwner();
      }

      setPresaleStarted(_presaleStarted);
      return _presaleStarted;
    } catch (error) {
      console.log(error);
      return false;
    }
  };

  const checkIfPresaleEnded = async () => {
    try {
      const provider = await getProviderOrSigner();

      const nftContract = new Contract(NFT_CONTRACT_ADDRESS, abi, provider);

      const _presaleEnded = await nftContract.presaleEnded();

      const hasEnded = _presaleEnded.lt(Math.floor(Date.now() / 1000));

      if (hasEnded) {
        setPresaleEnded(true);
      } else {
        setPresaleEnded(false);
      }

      return hasEnded;
    } catch (error) {
      console.log(error);
      return false;
    }
  };

  const getOwner = async () => {
    try {
      // Get the provider from web3Modal, which in our case is MetaMask
      // No need for the Signer here, as we are only reading state from the blockchain
      const provider = await getProviderOrSigner();
      // We connect to the Contract using a Provider, so we will only
      // have read-only access to the Contract
      const nftContract = new Contract(NFT_CONTRACT_ADDRESS, abi, provider);
      // call the owner function from the contract
      const _owner = await nftContract.owner();
      // Get the address associated to the signer which is connected to  MetaMask
      const signer = await getProviderOrSigner(true);
      // Get the address associated to the signer which is connected to  MetaMask
      const address = await signer.getAddress();

      if (address.toLowerCase() === _owner.toLowerCase()) {
        setIsOwner(true);
      }
    } catch (error) {
      console.log(error.message);
    }
  };

  return (
    <div>
      <Head>
        <title>Crypto Devs</title>
        <meta name="description" content="Whitelist-Dapp" />
        <link rel="icon" href="/favicon.ico" />
      </Head>
      <div className={styles.main}>
        <div>
          <h1 className={styles.title}>Welcome to Crypto Devs!</h1>
          <div className={styles.description}>
            Its an NFT collection for developers in Crypto.
          </div>
          <div className={styles.description}>
            {tokenIdsMinted}/20 have been minted
          </div>
          {/**renderButton()**/}
        </div>
        <div>
          <img className={styles.image} src="./cryptodevs/0.svg" />
        </div>
      </div>

      <footer className={styles.footer}>
        Made with &#10084; by Crypto Devs
      </footer>
    </div>
  );
}
