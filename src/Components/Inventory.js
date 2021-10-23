import React, {Component} from 'react'
import Navbar from 'react-bootstrap/Navbar'
import Container from 'react-bootstrap/Container'
import Nav from 'react-bootstrap/Nav'
import NavDropdown from 'react-bootstrap/NavDropdown'
import HoverDropdown from './HoverDropdown'

class Inventory extends Component{



getPilots = () => {
  const numPilots = [...Array(21).keys()];
  return numPilots.map((number)=> <NavDropdown.Item>Pilot {number}</NavDropdown.Item>);  
}

getPlanes = () => {
  const planes = ["FA-18E","FA-18E","FA-18E","FA-18F","FA-18F","FA-18F","FA-18F", "EA-18G", "EA-18G", "EA-18G", "EA-18G", "EA-18G"];
  return planes.map((plane)=> <NavDropdown.Item>{plane}</NavDropdown.Item>);  
}

getWeapons = () => {
  const numPilots = ["AGM-183A"];
  return numPilots.map((number)=> <NavDropdown.Item>{number}</NavDropdown.Item>);  
}

getShips = () => {
  const numPilots = [...Array(3).keys()];
  return numPilots.map((number)=> <NavDropdown.Item>Ship {number}</NavDropdown.Item>);  
}

render(){
return(<Navbar bg="dark" variant="dark" expand="lg" fixed="bottom">
<Container>
  <Navbar.Brand>Inventory/Laydown</Navbar.Brand>
  <Navbar.Toggle aria-controls="basic-navbar-nav" />
  <Navbar.Collapse id="basic-navbar-nav">
    <Nav className="me-auto">
    <HoverDropdown title="Pilots" 
                 id="basic-nav-dropdown"
                 drop="up">
            {this.getPilots()}
    </HoverDropdown>
      <HoverDropdown title="Planes" 
                   id="basic-nav-dropdown" 
                   drop="up">
        {this.getPlanes()}
      </HoverDropdown>
      <HoverDropdown title="Weapons" 
                   id="basic-nav-dropdown" 
                   drop="up">
        {this.getWeapons()}
      </HoverDropdown>
      <HoverDropdown title="Ships" 
                   id="basic-nav-dropdown" 
                   drop="up">
        {this.getShips()}
      </HoverDropdown>
    </Nav>
  </Navbar.Collapse>
</Container>
</Navbar>)
}
}

export default Inventory