import { Button } from 'react-bootstrap';

export function WalletComponent({ connected, getAccount, errorText, accountAddress }) {
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


