import React, {Component} from 'react'
import Navbar from 'react-bootstrap/Navbar'
import Container from 'react-bootstrap/Container'
import Nav from 'react-bootstrap/Nav'
import NavDropdown from 'react-bootstrap/NavDropdown'

class RestrictedNav extends Component{
  constructor(props){
    super(props);
    this.state = {missions: [], showForm:false};
  }

  handleActivateMission(e) {
    //window.alert(e)
  }

  createMission()  {
    

  }

  getMissions()  {
    if (this.state.missions.length > 0){
     return this.missions.map((mission) => <NavDropdown.Item>{mission}</NavDropdown.Item>)
    }
    else {
     return <NavDropdown.Item onClick={this.handleActivateMission()} >No Missions</NavDropdown.Item>
    }
  }

  render(){
    return (
      <>
    <Navbar bg="dark" variant="dark" expand="lg">
      <Container>
        <Navbar.Brand>Restricted Planning</Navbar.Brand>
        <Navbar.Toggle aria-controls="basic-navbar-nav" />
        <Navbar.Collapse id="basic-navbar-nav">
          <Nav className="me-auto">
          <NavDropdown title="File" id="basic-nav-dropdown">
            <NavDropdown.Item>Save</NavDropdown.Item>
            <NavDropdown.Item>Load</NavDropdown.Item>
            <NavDropdown.Divider />
            <NavDropdown.Item>Exit</NavDropdown.Item>
          </NavDropdown>
            <NavDropdown title="View" id="basic-nav-dropdown">
              <NavDropdown.Item>Zoom-in</NavDropdown.Item>
              <NavDropdown.Item>Zoom-out</NavDropdown.Item>
              <NavDropdown.Item>Reset</NavDropdown.Item>
              <NavDropdown.Divider />
              <NavDropdown.Item>Separated link</NavDropdown.Item>
            </NavDropdown>
            <NavDropdown title="Route" id="basic-nav-dropdown">
              <NavDropdown.Item>Auto route</NavDropdown.Item>
              <NavDropdown.Item>Another action</NavDropdown.Item>
              <NavDropdown.Item>Something</NavDropdown.Item>
              <NavDropdown.Divider />
              <NavDropdown.Item >Separated link</NavDropdown.Item>
            </NavDropdown>
            <NavDropdown title="Mission" id="basic-nav-dropdown">
              {this.getMissions()}
              <NavDropdown.Divider />
              <NavDropdown.Item onClick={() =>this.createMission()}>Add Mission</NavDropdown.Item>
            </NavDropdown>
          </Nav>
        </Navbar.Collapse>
        <Navbar.Brand >Active Mission: {this.activeMission}</Navbar.Brand>
      </Container>
    </Navbar>
    </>
    )
  }
}

export default RestrictedNav