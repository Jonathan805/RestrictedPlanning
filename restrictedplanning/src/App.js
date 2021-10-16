import React, { Component} from "react"
import './App.css';
import Nav from "./Components/Navbar";
import 'bootstrap/dist/css/bootstrap.css'
import TargetInfo from "./Components/TargetInfo";
import ship1Image from "./Images/1.png";
import ship2Image from "./Images/2.png"
import ship3Image from "./Images/3.png";
import ship4Image from "./Images/4.png"

const Targetsss = [{name: "Ship1", image:ship1Image},
                  {name: "Ship2", image: ship2Image},
                  {name: "Ship3", image: ship3Image},
                  {name: "Ship4", image: ship4Image}]

class App extends Component{
    render(){
      return (
        <div>
          <Nav />
          {Targetsss.map((target) => <TargetInfo name={target.name} image ={target.image}/>)}
        </div>
      );
    }
  }

export default App;
