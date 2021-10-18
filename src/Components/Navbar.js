import React, {Component} from 'react'
import Navbar from 'react-bootstrap/Navbar'
import Container from 'react-bootstrap/Container'
import Nav from 'react-bootstrap/Nav'
import NavDropdown from 'react-bootstrap/NavDropdown'

class RestrictedNav extends Component{
  render(){
    return (
    <Navbar bg="light" expand="lg">
      <Container>
        <Navbar.Brand href="#home">Restricted Planning</Navbar.Brand>
        <Navbar.Toggle aria-controls="basic-navbar-nav" />
        <Navbar.Collapse id="basic-navbar-nav">
          <Nav className="me-auto">
          <NavDropdown title="File" id="basic-nav-dropdown">
            <NavDropdown.Item href="#action/3.1">Save</NavDropdown.Item>
            <NavDropdown.Item href="#action/3.2">Load</NavDropdown.Item>
            <NavDropdown.Divider />
            <NavDropdown.Item href="#action/3.4">Exit</NavDropdown.Item>
          </NavDropdown>
            <NavDropdown title="View" id="basic-nav-dropdown">
              <NavDropdown.Item href="#action/3.1">Zoom-in</NavDropdown.Item>
              <NavDropdown.Item href="#action/3.2">Zoom-out</NavDropdown.Item>
              <NavDropdown.Item href="#action/3.3">Reset</NavDropdown.Item>
              <NavDropdown.Divider />
              <NavDropdown.Item href="#action/3.4">Separated link</NavDropdown.Item>
            </NavDropdown>
            <NavDropdown title="Route" id="basic-nav-dropdown">
              <NavDropdown.Item href="#action/3.1">Auto route</NavDropdown.Item>
              <NavDropdown.Item href="#action/3.2">Another action</NavDropdown.Item>
              <NavDropdown.Item href="#action/3.3">Something</NavDropdown.Item>
              <NavDropdown.Divider />
              <NavDropdown.Item href="#action/3.4">Separated link</NavDropdown.Item>
            </NavDropdown>
          </Nav>
        </Navbar.Collapse>
      </Container>
    </Navbar>
    )
  }
}

export default RestrictedNav