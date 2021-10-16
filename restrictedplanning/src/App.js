import React, { Component} from "react"
import './App.css';
import Nav from "./Components/Navbar";
import 'bootstrap/dist/css/bootstrap.css'
import TargetInfo from "./Components/TargetInfo";
import ship1Image from "./Images/1.png";

class App extends Component{
    render(){
      return (
        <div>
          <Nav />
          <TargetInfo name="Ship1" image={ship1Image}/>
        </div>
      );
    }
  }

export default App;
