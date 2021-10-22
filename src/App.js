import React, { Component } from "react"
import './App.css';
import Nav from "./Components/Navbar";
import Inventory from "./Components/Inventory";
import 'bootstrap/dist/css/bootstrap.css'
import Row from "react-bootstrap/Row"
import TargetList from "./Components/TargetList";

import Board from './Components/Board';
import Card from "./Components/Card";

import Growler from './AircraftImages/Growler.png';
import F35 from './AircraftImages/F35.png';
import B2 from './AircraftImages/B2.png';

class App extends Component {


  render() {
    return (
      <div>
        <Nav />
        <section id="section-left">
          <main className="flexbox" >
            <Board id="board-1" className="board" >
              <center><h3>Inventory</h3></center>
              <Card id="Aircraft-1" className="aircraft" draggable="true">
                <p>F-35
                <br></br>
                  <img src={F35} alt="F35" />
                  <select name="count" id="count">
                    <option value="1">1</option>
                    <option value="2">2</option>
                  </select>
                </p>
              </Card>

              <Card id="Aircraft-2" className="aircraft" draggable="true">
                <p>Growler
                <br></br><img src={Growler} alt="Growler" />
                  <select name="count" id="count">
                    <option value="1">1</option>
                    <option value="2">2</option>
                    <option value="3">3</option>
                  </select>
                </p>
              </Card>

              <Card id="Aircraft-4" className="aircraft" draggable="true">
                <p>B2 <br></br>
                  <img src={B2} alt="B2" /></p>
                <select name="count" id="count">
                  <option value="1">1</option>
                  <option value="2">2</option>
                  <option value="3">3</option>
                  <option value="4">4</option>
                </select>
              </Card>
            </Board>
            <Board id="board-2" className="board">
              <center><h3>Mission</h3></center>

            </Board>
          </main>
        </section>


        <missionplanning className="missionfunctions">
          <section className="section-right">
            <Row>
              <TargetList />
            </Row>
          </section>
        </missionplanning>

        <Inventory />
      </div>
    );
  }
}

export default App;
