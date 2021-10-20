import React, { Component} from "react"
import './App.css';
import Nav from "./Components/Navbar";
import Inventory from "./Components/Inventory";
import 'bootstrap/dist/css/bootstrap.css'
import Row from "react-bootstrap/Row"
import TargetList from "./Components/TargetList";

class App extends Component{
    render(){
      return (
        <div>
          <Nav />
            <Row>
                <TargetList />            
            </Row>
            <Inventory />
        </div>      
      );
    }
  }

export default App;
