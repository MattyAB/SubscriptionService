// import logo from './logo.svg';
// import './App.css';

// function App() {
//   return (
//     <div className="App">
//       <header className="App-header">
//         <img src={logo} className="App-logo" alt="logo" />
//         <p>
//           Edit <code>src/App.js</code> and save to reload.
//         </p>
//         <a
//           className="App-link"
//           href="https://reactjs.org"
//           target="_blank"
//           rel="noopener noreferrer"
//         >
//           Learn React
//         </a>
//       </header>
//     </div>
//   );
// }

// export default App;

import React, { useState, Component } from 'react'
import { NavBar, SubscriptionContent, Footer } from './my-react-components'
import { WalletComponent } from './WalletConnection';
import { Container } from 'react-bootstrap';
// import "./WalletConnection"

class App extends Component {
  render() {
    return (
      <body>
        <NavBar></NavBar>
        <Container fluid className="d-flex flex-column align-items-center">
          <WalletComponent></WalletComponent>
          <SubscriptionContent></SubscriptionContent>
        </Container>
        <Footer></Footer>
      </body>

      // <body class="d-flex flex-column h-100">
      //   <header class="d-flex flex-wrap justify-content-center py-3 mb-4 border-bottom">
      //     <a href="/" class="d-flex align-items-center mb-3 mb-md-0 me-md-auto link-body-emphasis text-decoration-none">
      //       <svg class="bi me-2" width="40" height="32"></svg>
      //       <span class="fs-4">Our Project</span>
      //     </a>

      //     <ul class="nav nav-pills">
      //       <li class="nav-item"><button type="button" class="btn" data-bs-toggle="modal" data-bs-target="#exampleModal">
      //         My Subscription
      //       </button><svg class="bi me-2" width="40" height="32"></svg></li>
      //     </ul>
      //   </header>

      //   <footer class="footer mt-auto py-3 bg-body-tertiary fixed-bottom">
      //     <div class="container">
      //       <span class="text-body-secondary">Subscription Project ETHGlobal London</span>
      //     </div>
      //   </footer>
      // </body>

    );
  }
}

export default App;