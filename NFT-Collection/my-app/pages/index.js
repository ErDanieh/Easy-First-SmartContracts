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
