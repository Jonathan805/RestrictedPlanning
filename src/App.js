import React, { Component } from "react"
import './App.css';
import Nav from "./Components/Navbar";
import Inventory from "./Components/Inventory";
import 'bootstrap/dist/css/bootstrap.css'
import Row from "react-bootstrap/Row"
import TargetList from "./Components/TargetList";


import ToastMessage from "./Components/ToastMessage";
import TaskList from "./Components/CustomTimeline/components/taskList/TaskList";
import { DataViewPort } from "./Components/CustomTimeline/components/viewport/DataViewPort";

// Components for click and drag Aircraft selections
import Board from './Components/Board';
import Card from "./Components/Card";
import Aircraft from "./Components/Aircraft";
import Growler from './AircraftImages/Growler.png';
import FA18F from './AircraftImages/FA-18A.png';
import F35 from './AircraftImages/F35.png';
import B2 from './AircraftImages/B2.png';

// Components for creating Targets
import Header from './Components/Header';
import Targets from './Components/Targets';
import CreateTarget from './Components/CreateTarget';
import { useState, useEffect } from 'react'


const App = () => {
  var showToast = (message) => {
    <></>
  }

  var Toast = () => { <ToastMessage /> }

  const [targets, setTargets] = useState([])

  // Create a target
  const createTarget = async (task) => {
    const res = await fetch('http://localhost:5000/targets', {
      method: 'POST',
      headers: {
        'Content-type': 'application/json'
      },
      body: JSON.stringify(task)
    })

    const data = await res.json()

    //setTasks([...task, data])
    //console.log(task)
    alert(JSON.stringify(data))
  }

    return (
      <div>
        <Nav />
        <section id="section-left">
          <main className="flexbox" >
            <Board id="board-1" className="board" >
              <center><h3>Inventory</h3></center>
              <Card id="Aircraft-1" className="aircraft" draggable="true">
                <Aircraft aircraftName='EA-18G (Growler)' image={Growler} />
              </Card>
              <Card id="Aircraft-2" className="aircraft" draggable="true">
                <Aircraft aircraftName='FA-18F (Hornet)' image={FA18F} />
              </Card>
              <Card id="Aircraft-3" className="aircraft" draggable="true">
                <Aircraft aircraftName='F35' image={F35} />
              </Card>
              <Card id="Aircraft-4" className="aircraft" draggable="true">
                <Aircraft aircraftName='B2' image={B2} />
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
                <TargetList />
              </Row>
            </section>
            <br />
            <section className="section-top">
              <Header />
              <CreateTarget createTarget={createTarget} />
              <Targets/>
            </section>
          </section>

        </missionplanning>

        <Inventory />
      </div>
    );
  }

export default App;
