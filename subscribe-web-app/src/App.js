import React, { useState, Component } from 'react'
import { NavBar, SubscriptionContent, Footer } from './my-react-components'
import { WalletComponent } from './WalletConnection';
import { Container } from 'react-bootstrap';
import detectEthereumProvider from '@metamask/detect-provider';

const provider = await detectEthereumProvider();

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

  if (provider) {
    startApp(provider);
  } else {
    console.log('Please install MetaMask!');
  }

  function startApp(provider) {
    if (provider !== window.ethereum) {
      console.error('Do you have multiple wallets installed?');
    }
  }

  async function getAccount() {
    const accounts = await window.ethereum.request({ method: 'eth_requestAccounts' })
      .catch((err) => {
        if (err.code === 4001) {
          console.log('Please connect to MetaMask.');
        } else {
          console.error(err);
        }
      });
    try {
      const account = accounts[0];
      setAccountAddress(account)
      setWalletConnectErrorText("")
      setConnected(true)
      checkSubscribed(account)
    } catch (err) {
      console.log(err)
      setWalletConnectErrorText("Please try again.")
    }
  }

  function subscribe() {
    subscribers[accountAddress] = true
    checkSubscribed(accountAddress)
  }


  return (
    <>
      <NavBar subscribed={subscribed}></NavBar>
      <Container fluid className="d-flex flex-column align-items-center">
        <WalletComponent connected={connected} getAccount={getAccount} errorText={walletConnectErrorText} accountAddress={accountAddress}></WalletComponent>
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