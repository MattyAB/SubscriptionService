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

import React, { Component } from 'react'
// import './App.css'

function Profile() {
  return (
    <p>Hi</p>
  );
}

class App extends Component {
  render() {
    return (


      <body class="d-flex flex-column h-100">
        <header class="d-flex flex-wrap justify-content-center py-3 mb-4 border-bottom">
          <a href="/" class="d-flex align-items-center mb-3 mb-md-0 me-md-auto link-body-emphasis text-decoration-none">
            <svg class="bi me-2" width="40" height="32"></svg>
            <span class="fs-4">Our Project</span>
          </a>

          <ul class="nav nav-pills">
            <li class="nav-item"><button type="button" class="btn" data-bs-toggle="modal" data-bs-target="#exampleModal">
              My Subscription
            </button><svg class="bi me-2" width="40" height="32"></svg></li>
          </ul>
        </header>

        {/* <div class="modal fade" id="exampleModal" tabIndex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
          <div class="modal-dialog">
            <div class="modal-content">
              <div class="modal-header">
                <h1 class="modal-title fs-5" id="exampleModalLabel">Modal title</h1>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
              </div>
              <div class="modal-body">
                <p>You're subscribed</p>
              </div>
              <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
              </div>
            </div>
          </div>
        </div> */}
        {/* <main class="flex-shrink-0">
            <div class="container">
              <h1 class="mt-5">Sticky footer</h1>
              <p class="lead">Pin a footer to the bottom of the viewport in desktop browsers with this custom HTML and CSS.</p>
              <p>Use <a href="/docs/5.3/examples/sticky-footer-navbar/">the sticky footer with a fixed navbar</a> if need be, too.</p>
            </div>
          </main> */}

        <footer class="footer mt-auto py-3 bg-body-tertiary fixed-bottom">
          <div class="container">
            <span class="text-body-secondary">Subscription Project ETHGlobal London</span>
          </div>
        </footer>
      </body>

    );
  }
}

export default App;