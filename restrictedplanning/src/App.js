import React, { Component} from "react"
import './App.css';
import Nav from "./Components/Navbar";
import 'bootstrap/dist/css/bootstrap.css'
import Container from "react-bootstrap/esm/Container";
import Row from "react-bootstrap/Row"
import TargetInfo from "./Components/TargetInfo";
import ship1Image from "./Images/1.png";
import ship2Image from "./Images/2.png"
import ship3Image from "./Images/3.png";
import ship4Image from "./Images/4.png"
import TargetList from "./Components/TargetList";


const Targetsss = [
  {name: "Ship1", image: ship1Image, latitude: "21.3496711", longitude: "-157.9685571,7858", elevation:"0 MSL"},
  {name: "Ship2", image: ship2Image, latitude: "21.3496711", longitude: "-157.9685571,7858", elevation:"0 MSL"},
  {name: "Ship3", image: ship3Image, latitude: "21.3496711", longitude: "-157.9685571,7858", elevation:"0 MSL"},
  {name: "Ship4", image: ship4Image, latitude: "21.3496711", longitude: "-157.9685571,7858", elevation:"0 MSL"}
]

class App extends Component{
    render(){
      return (
        <div>
          <Nav />
          <Container>
            <Row>
              {/* {Targetsss.map((target) => 
                <TargetInfo targetName={target.name} 
                            targetImage ={target.image}
                            latitude = {target.latitude}
                            longitude = {target.longitude}
                            elevation = {target.elevation}/>)} */}
                <TargetList />
              </Row>
            </Container>
        </div>
      );
    }
  }

export default App;
