import React, { useState, Component } from 'react'
import { NavBar, SubscriptionContent, Footer } from './my-react-components'
import { WalletComponent } from './WalletConnection';
import { Container } from 'react-bootstrap';

function PageContent() {
  const [connected, setConnected] = useState(false)
  return (
    <>
      <NavBar></NavBar>
      <Container fluid className="d-flex flex-column align-items-center">
        <WalletComponent connected={connected} setConnected={setConnected}></WalletComponent>
        <SubscriptionContent></SubscriptionContent>
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