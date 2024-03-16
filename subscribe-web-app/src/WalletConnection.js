import detectEthereumProvider from '@metamask/detect-provider';
import { useState } from 'react';
import { Button } from 'react-bootstrap';

const provider = await detectEthereumProvider();



export function WalletComponent({ connected, setConnected }) {
    const [errorText, setErrorText] = useState("")
    const [accountAddress, setAccountAddress] = useState("")

    function ConnectButton() {
        if (!connected) {
            return (<Button className="metamask-btn" onClick={getAccount}>Connect Metamask</Button>)
        }
    }

    function ConnectedStatus() {
        if (connected) {
            return (<p className="text-wrap">Connected to account {accountAddress}</p>)
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
            setErrorText("")
            setConnected(true)
        } catch (err) {
            console.log(err)
            setErrorText("Please try again.")
        }
    }

    return (
        <>
            <style type="text/css">
                {`
    .metamask-btn {
      background-color: white;
      color: orange;
      border: 1px solid orange;
    }
    .metamask-btn:hover {
        background-color: orange; /* Change background color on hover */
        border: 1px solid orange;
      }
    .metamask-btn:active {
        background-color: #ff8c00 !important;
        border: 1px solid orange !important;
    }
    `}
            </style>
            <ConnectButton></ConnectButton>
            <ConnectedStatus></ConnectedStatus>
            <p>{errorText}</p>
        </>
    )
}


