// import Container from 'react-bootstrap/Container';
// import Nav from 'react-bootstrap/Nav';
// import Navbar from 'react-bootstrap/Navbar';
import {
    Button,
    Container,
    Nav,
    Navbar,
    PageItem
} from 'react-bootstrap'

export function NavBar() {
    return (
        <Navbar expand="lg" className="bg-body-tertiary py-3 mb-4 border-bottom">
            <Container className='d-flex justify-content-between'>
                <Navbar.Brand href="">React-Bootstrap</Navbar.Brand>
                <Nav className="ms-auto">
                    <Button>My Subscription</Button>
                </Nav>
            </Container>
        </Navbar>
    );
}

export function Footer() {
    return (
        <Container fluid className="footer mt-auto py-3 bg-body-tertiary fixed-bottom">
            <span class="text-body-secondary">Subscription Project ETHGlobal London</span>
        </Container>
    )
}

// export default BasicExample;