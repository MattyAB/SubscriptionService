// import Container from 'react-bootstrap/Container';
// import Nav from 'react-bootstrap/Nav';
// import Navbar from 'react-bootstrap/Navbar';
import { useState, useRef } from 'react'
import {
    Button,
    Container,
    Nav,
    Navbar,
    Modal,
    Row,
    Card
} from 'react-bootstrap'

export function NavBar() {
    const [modalShowStatus, setShowModal] = useState(false);

    const handleCloseModal = () => {
        setShowModal(false);
    }
    const handleShowModal = () => setShowModal(true);
    return (
        <>
            <Navbar expand="lg" className="bg-body-tertiary py-3 mb-4 border-bottom">
                <Container fluid>
                    <Navbar.Brand href="home" className='ms-3'>SubHub</Navbar.Brand>
                    <Nav className='me-5'>
                        <Button variant='primary' onClick={handleShowModal}>My Subscription</Button>
                    </Nav>
                </Container>
            </Navbar>

            <Modal show={modalShowStatus} onHide={handleCloseModal} animation={false}>
                <Modal.Header closeButton>
                    <Modal.Title>Your Subscription Status</Modal.Title>
                </Modal.Header>
                <Modal.Body>
                    <Container className='px-3'>
                        <Row>You are: Subscribed</Row>
                        <Row>Last Payment: </Row>
                        <Row>Next Payment Due:</Row>
                    </Container>
                </Modal.Body>
                <Modal.Footer>
                    <Button variant="secondary" onClick={handleCloseModal}>
                        Close
                    </Button>
                </Modal.Footer>
            </Modal>
        </>
    );
}

export function SubscriptionContent() {

    return (
        <Container className="d-flex flex-column align-items-center">
            <h1>Welcome</h1>
            <Card style={{ width: '18rem' }}>
                <Card.Body className="d-flex flex-column align-items-center">
                    <Card.Title>You are not logged in</Card.Title>
                    <Card.Text>
                        Click the button below to sign in or subscribe.
                    </Card.Text>
                    <Button variant="primary">Verify</Button>
                </Card.Body>
            </Card>
        </Container>
    )
}

export function Footer() {
    return (
        <Container fluid className="footer mt-auto py-3 bg-body-tertiary fixed-bottom">
            <span class="text-body-secondary">Subscription Project ETHGlobal London</span>
        </Container>
    )
}

// export default BasicExample;