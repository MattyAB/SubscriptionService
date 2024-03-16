import React, { useState, Component } from 'react'
import { NavBar, SubscriptionContent, Footer } from './my-react-components'
import { WalletComponent } from './WalletConnection';
import { Container } from 'react-bootstrap';
import detectEthereumProvider from '@metamask/detect-provider';
import { MetaMaskWallet, SmartWallet } from "@thirdweb-dev/wallets";
import { Sepolia } from "@thirdweb-dev/chains"

// const provider = await detectEthereumProvider();

function PageContent() {
  const [connected, setConnected] = useState(false)
  const [subscribed, setSubscribed] = useState(false)
  const [walletConnectErrorText, setWalletConnectErrorText] = useState("")
  const [accountAddress, setAccountAddress] = useState("")

  const subscribers = {
    // "0xe2ca86422b06cd89532aab35b03e87de6c345159": true,
  }

  function checkSubscribed(accountAddress) {
    if (subscribers.hasOwnProperty(accountAddress)) {
      setSubscribed(true)
    }
  }

  async function connectMetaMask() {
    const personalWallet = new MetaMaskWallet({
      clientId: "97c1d7a82eae7d2b4c4563c09874f7cf",
      chains: [Sepolia],
    });
    try {
      await personalWallet.connect()
      const address = await personalWallet.getAddress()
      console.log(address)
      setAccountAddress(address)
      setWalletConnectErrorText("")
      setConnected(true)
      checkSubscribed(address)
      const smartWallet = new SmartWallet(config)
      console.log(smartWallet)
      await smartWallet.connect({
        personalWallet,
      })
    } catch (err) {
      console.log(err)
      setWalletConnectErrorText("Please try again.")
    }
    // console.log(wallet)
  }

  const config = {
    chain: Sepolia, // the chain where your smart wallet will be or is deployed
    factoryAddress: "0xCb5894a8C4d5686AaFeAE5Dc0776DF1e6a9F2D8b", // your own deployed account factory address
    clientId: "97c1d7a82eae7d2b4c4563c09874f7cf", // Use client id if using on the client side, get it from dashboard settings
    // secretKey: "bA5Oe8xjqkOJGsufMxp8DpbW1yXyn3-CWTZsZluuJkcQAMIBxw6iAxIiRqM0ehqoTlSVWaRTbzWdYuUdKNQXyw", // Use secret key if using on the server, get it from dashboard settings
    gasless: false, // enable or disable gasless transactions
    chains: [Sepolia],
  };



  // if (provider) {
  //   startApp(provider);
  // } else {
  //   console.log('Please install MetaMask!');
  // }

  // function startApp(provider) {
  //   if (provider !== window.ethereum) {
  //     console.error('Do you have multiple wallets installed?');
  //   }
  // }

  // async function getAccount() {
  //   const accounts = await window.ethereum.request({ method: 'eth_requestAccounts' })
  //     .catch((err) => {
  //       if (err.code === 4001) {
  //         console.log('Please connect to MetaMask.');
  //       } else {
  //         console.error(err);
  //       }
  //     });
  // try {
  //   const account = accounts[0];
  //   setAccountAddress(account)
  //   setWalletConnectErrorText("")
  //   setConnected(true)
  //   checkSubscribed(account)
  // } catch (err) {
  //   console.log(err)
  //   setWalletConnectErrorText("Please try again.")
  // }
  // }

  function subscribe() {
    subscribers[accountAddress] = true
    checkSubscribed(accountAddress)
  }


  return (
    <>
      <NavBar subscribed={subscribed}></NavBar>
      <Container fluid className="d-flex flex-column align-items-center">
        <WalletComponent connected={connected} getAccount={connectMetaMask} errorText={walletConnectErrorText} accountAddress={accountAddress}></WalletComponent>
        <SubscriptionContent connected={connected} subscribed={subscribed} subscribe={subscribe}></SubscriptionContent>
      </Container>
      <Footer></Footer>
    </>
  )
}

class App extends Component {
  render() {
    return (
      <PageContent></PageContent>
    );
  }
}

export default App;