import React, {Component} from 'react'
import Navbar from 'react-bootstrap/Navbar'
import Container from 'react-bootstrap/Container'
import Nav from 'react-bootstrap/Nav'
import NavDropdown from 'react-bootstrap/NavDropdown'
import HoverDropdown from './HoverDropdown'

class Inventory extends Component{



getPilots = () => {
  const numPilots = [...Array(21).keys()];
  return numPilots.map((number)=> <NavDropdown.Item>Pilot {number+1}</NavDropdown.Item>);  
}

getPlanes = () => {
  const planes = ["FA-18E",
                  "FA-18E",
                  "FA-18E",
                  "FA-18F",
                  "FA-18F",
                  "FA-18F",
                  "FA-18F", 
                  "EA-18G", 
                  "EA-18G",
                  "EA-18G", 
                  "EA-18G", 
                  "EA-18G"];
  return planes.map((plane)=> <NavDropdown.Item>{plane}</NavDropdown.Item>);  
}

getWeapons = () => {
  const numWeapons = ["AGM-183A"];
  return numWeapons.map((number)=> <NavDropdown.Item>{number}</NavDropdown.Item>);  
}

getShips = () => {
  const numsShips = [...Array(3).keys()];
  return numsShips.map((number)=> <NavDropdown.Item>Ship {number+1}</NavDropdown.Item>);  
}

getHelos = () => {
  const numHelos = [...Array(4).keys()];
  return numHelos.map((number)=> <NavDropdown.Item>Helo {number+1}</NavDropdown.Item>);  
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
      <HoverDropdown title="Helos" 
                   id="basic-nav-dropdown" 
                   drop="up">
        {this.getHelos()}
      </HoverDropdown>
    </Nav>
  </Navbar.Collapse>
</Container>
</Navbar>)
}
}

export default Inventory