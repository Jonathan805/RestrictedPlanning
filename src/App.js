import React, { Component} from "react"
import './App.css';
import Nav from "./Components/Navbar";
import 'bootstrap/dist/css/bootstrap.css'
import Container from "react-bootstrap/esm/Container";
import Row from "react-bootstrap/Row"
import TargetList from "./Components/TargetList";

class App extends Component{
    render(){
      return (
        <div>
          <Nav />
          <Container>
            <Row>
                <TargetList />            
              </Row>
            </Container>
        </div>
      );
    }
  }

export default App;
