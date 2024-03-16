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

export function NavBar({ subscribed }) {
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
                        {subscribed ? <Button variant='primary' onClick={handleShowModal} show={false}>My Subscription</Button> : null}
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

export function SubscriptionContent({ connected, subscribed }) {
    function CardContent({ connected, subscribed }) {
        if (!connected) {
            return (
                <Card.Body className="d-flex flex-column align-items-center">
                    <Card.Title className="text-center">You have not connected a wallet</Card.Title>
                    <Card.Text>
                        Click the button above to connect your metamask.
                    </Card.Text>
                </Card.Body>
            )
        } else if (!subscribed) {
            return (
                <Card.Body className="d-flex flex-column align-items-center">
                    <Card.Title className="text-center">You are not subscribed</Card.Title>
                    <Card.Text>
                        Click the button below to subscribe.
                    </Card.Text>
                    <Button>Subscribe</Button>
                </Card.Body>
            )
        } else {
            return (
                <Card.Body className="d-flex flex-column align-items-center">
                    <Card.Title className="text-center">You are subscribed!</Card.Title>
                </Card.Body>
            )
        }

    }
    return (
        <Container className="d-flex flex-column align-items-center">
            <h1>Welcome</h1>
            <Card style={{ width: '18rem' }}>
                <CardContent connected={connected} subscribed={subscribed}></CardContent>
            </Card>
        </Container>
    )
}

export function Footer() {
    return (
        <Container fluid className="footer mt-auto py-3 bg-body-tertiary fixed-bottom">
            <span className="text-body-secondary">Subscription Project ETHGlobal London</span>
        </Container>
    )
}
