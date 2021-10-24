import React, { Component } from "react"
import { useState, useEffect} from 'react'
import './App.css';
import Nav from "./Components/Navbar";
import Inventory from "./Components/Inventory";
import 'bootstrap/dist/css/bootstrap.css'
import Row from "react-bootstrap/Row"
import TargetList from "./Components/TargetList";

import CreateTarget from './Components/CreateTarget';

import Board from './Components/Board';
import Card from "./Components/Card";

import Growler from './AircraftImages/Growler.png';
import F35 from './AircraftImages/F35.png';
import B2 from './AircraftImages/B2.png';
import FA18F from './AircraftImages/FA-18A.png';
import ToastMessage from "./Components/ToastMessage";
import TaskList from "./Components/CustomTimeline/components/taskList/TaskList";
import { DataViewPort } from "./Components/CustomTimeline/components/viewport/DataViewPort";



class App extends Component {
  showToast =  (message) =>  {
    <></>
  }

  Toast = () => {<ToastMessage/>}


  createTarget = async (task) => {
    
    const res = await fetch('http://localhost:5000/targets', {
      method: 'POST',
      headers: {
        'Content-type' : 'application/json'
      },
      body: JSON.stringify(task)
    })

    const data = await res.json()

    //setTasks([...task, data])
    //console.log(task)
    alert(JSON.stringify(data))
  }

  render() {
    return (
      <div>
        <Nav />
        <section id="section-left">
          <main className="flexbox" >
            <Board id="board-1" className="board" >
              <center><h3>Inventory</h3></center>
              <Card id="Aircraft-2" className="aircraft" draggable="true">
                <p>EA-18G (Growler)
                <br></br><img src={Growler} alt="Growler" />
                  <select name="count" id="count">
                    <option value="1">1</option>
                    <option value="2">2</option>
                    <option value="3">3</option>
                  </select>
                </p>
              </Card>

              <Card id="Aircraft-3" className="aircraft" draggable="true">
                <p>FA-18F (Hornet)
                <br></br><img src={FA18F} alt="FA-18F" />
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
            </Board>
            <Board id="board-2" className="board">
              <center><h3>Mission</h3></center>

            </Board>

          </main>
        </section>


        <missionplanning className="missionfunctions">
          <section className="section-right">
            <section className="section-top">
              <Row>
                <TargetList/>
              </Row>
            </section>
            <br/>
            <section className="section-top">
              <CreateTarget createTarget={this.createTarget}/>
            </section>
          </section>

        </missionplanning>

        <Inventory />
      </div>
    );
  }
}

export default App;
