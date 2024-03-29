import Head from "next/head";
import styles from "../styles/Home.module.css";
import Web3Modal from "web3modal";
import { providers, Contract } from "ethers";
import { useEffect, useRef, useState } from "react";
import { WHITELIST_CONTRACT_ADDRESS, abi } from "../constants";


export default function Home(){

  const [walletConnected, setWalletConnected] =  useState(false);

  const [joinedWhitelist, setJoinedWhitelist] = useState(false);

  const [loading, setLoading] = useState(false);

  const [numberOfWhitelisted, setNumberOfWhitelisted] = useState(0);
  
  const Web3ModalRef = useRef();


  /**
   * A `Provider` is needed to interact with the blockchain - reading transactions, reading balances, reading state, etc.
   * @param {*} needSigner 
   */
  const getProviderOrSigner = async (needSigner = false) => {

    const provider = await Web3ModalRef.current.connect();

    const web3Provider = new providers.Web3Provider(provider);

    const {chainId} = await web3Provider.getNetwork();

    if(chainId !== 5){
      window.alert('Change network to Goerli');
      throw new Error('Change The network')
    }

    if (needSigner){
      const signer  = web3Provider.getSigner();
      return signer;
    }

    return web3Provider;
  }

  const addAddressToWhitelist = async () =>
  {
    try{
      const signer = await getProviderOrSigner(true);

      const whitelistContract = new Contract(
        WHITELIST_CONTRACT_ADDRESS,
        abi,
        signer
      );

      const tx = await whitelistContract.addAddressToWhitelist();
      setLoading(true);
      
      //Esperamos a que la transaccion sea minada
      await tx.wait();

      setLoading(false);

      await getNumberOfWhitelisted();

      setJoinedWhitelist(true);

    }catch(error){
      console.error(err);
    }
  }

  const getNumberOfWhitelisted = async () => {
    try{

      const provider = await getProviderOrSigner();

      //read-only no gastamos ether
      const whitelistContract =  new Contract(
        WHITELIST_CONTRACT_ADDRESS,
        abi,
        provider
      );

      const _numberOfWhitelisted = await whitelistContract.numAddressesWhitelisted();

      setNumberOfWhitelisted(_numberOfWhitelisted);

    }catch(err){
      console.error(err)
    }
  }

  const checkIfAddressInWhitelist = async() => {
    try{

      const signer = await getProviderOrSigner(true);

      const whitelistContract = new Contract(
        WHITELIST_CONTRACT_ADDRESS,
        abi,
        signer
      );

      const address = await signer.getAddress();

      const _joinedWhitelist = await whitelistContract.whitelistedAddress(address);

      setJoinedWhitelist(_joinedWhitelist);

    }catch(err){
      console.error(err);
    }
  }

  const connectWallet = async() => {
    try{

      await getProviderOrSigner();
      setWalletConnected(true);

      checkIfAddressInWhitelist();

      getNumberOfWhitelisted();
    }catch(err){
      console.error(err);
    }
  }

    /*
    renderButton: Returns a button based on the state of the dapp
  */
    const renderButton = () => {
      if (walletConnected) {
        if (joinedWhitelist) {
          return (
            <div className={styles.description}>
              Thanks for joining the Whitelist!
            </div>
          );
        } else if (loading) {
          return <button className={styles.button}>Loading...</button>;
        } else {
          return (
            <button onClick={addAddressToWhitelist} className={styles.button}>
              Join the Whitelist
            </button>
          );
        }
      } else {
        return (
          <button onClick={connectWallet} className={styles.button}>
            Connect your wallet
          </button>
        );
      }
    };

      // useEffects are used to react to changes in state of the website
  // The array at the end of function call represents what state changes will trigger this effect
  // In this case, whenever the value of `walletConnected` changes - this effect will be called
  useEffect(() => {
    // if wallet is not connected, create a new instance of Web3Modal and connect the MetaMask wallet
    if (!walletConnected) {
      // Assign the Web3Modal class to the reference object by setting it's `current` value
      // The `current` value is persisted throughout as long as this page is open
      Web3ModalRef.current = new Web3Modal({
        network: "goerli",
        providerOptions: {},
        disableInjectedProvider: false,
      });
      connectWallet();
    }
  }, [walletConnected]);

  return (
    <div>
      <Head>
        <title>Whitelist Dapp</title>
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
            {numberOfWhitelisted} have already joined the Whitelist
          </div>
          {renderButton()}
        </div>
        <div>
          <img className={styles.image} src="./crypto-devs.svg" />
        </div>
      </div>

      <footer className={styles.footer}>
        Made with &#10084; by Crypto Devs
      </footer>
    </div>
  );
}