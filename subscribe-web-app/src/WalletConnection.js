// import React, { useState } from 'react';
// import Button from 'react-bootstrap/Button'
// import { ethers, providers } from "ethers";
// const provider = new ethers.providers.Web3Provider(window.Ethereum)
// // const provider = new providers.AlchemyProvider("homestead", "2jSgCQ15eGp04K55iljm015-XrA4gBEO")

// const WalletComponent = () => {
//     const [errorMessage, setErrorMessage] = useState(null);
//     const [defaultAccount, setDefaultAccount] = useState(null);
//     const [userBalance, setUserBalance] = useState(null);
//     const connectwalletHandler = () => {
//         if (window.ethereum) {
//             provider.send("eth_requestAccounts", [])
//                 .then(async () => {
//                     await accountChangedHandler(provider.getSigner());
//                 })
//         } else {
//             setErrorMessage("Please Install MetaMask!!!");
//         }
//     }

//     const accountChangedHandler = async (newAccount) => {
//         const address = await newAccount.getAddress();
//         setDefaultAccount(address);
//         const balance = await newAccount.getBalance()
//         setUserBalance(ethers.utils.formatEther(balance));
//         await getuserBalance(address)
//     }

//     const getuserBalance = async (address) => {
//         const balance = await provider.getBalance(address, "latest")
//     }

//     return (
//         <div className="WalletCard">
//             <h3 className="h4">
//                 Welcome to a decentralized Application
//             </h3>
//             <Button
//                 style={{ background: defaultAccount ? "#A5CC82" : "white" }}
//                 onClick={connectwalletHandler}>
//                 {defaultAccount ? "Connected!!" : "Connect"}
//             </Button>
//             <div className="displayAccount">
//                 <h4 className="walletAddress">Address:{defaultAccount}</h4>
//                 <div className="balanceDisplay">
//                     <h3>
//                         Wallet Amount: {userBalance}
//                     </h3>
//                 </div>
//             </div>
//             {errorMessage}
//         </div>
//     )
// }

// export default WalletComponent;

// Detect the MetaMask Ethereum provider

import detectEthereumProvider from '@metamask/detect-provider';
import { useState } from 'react';
import { Button } from 'react-bootstrap';

const provider = await detectEthereumProvider();



export function WalletComponent({ connected, setConnected }) {
    // const connected = false
    const [errorText, setErrorText] = useState("")
    // const [connected, setConnected] = useState(false)
    const [accountAddress, setAccountAddress] = useState("")

    function ConnectButton() {
        if (!connected) {
            return (<Button className="metamask-btn" onClick={getAccount}>Connect Metamask</Button>)
        }
    }

    function ConnectedStatus() {
        if (connected) {
            return (<p>Connected to account {accountAddress}</p>)
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

    // Prompt users to connect to MetaMask

    // const ethereumButton = document.querySelector('.enableEthereumButton');
    // const showAccount = document.querySelector('.showAccount');

    // ethereumButton.addEventListener('click', () => {
    //     getAccount();
    // });

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
        // showAccount.innerHTML = account;
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
            {/* <Button className="metamask-btn" onClick={getAccount}>Connect Metamask</Button> */}
            <p>{errorText}</p>
        </>
    )
}


