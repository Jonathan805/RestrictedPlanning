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
import Button from './Components/Button';
import CreateTarget from './Components/CreateTarget';
import { useState, useEffect } from 'react'


const App = () => {
  var showToast = (message) => {
    <></>
  }

  var Toast = () => { <ToastMessage /> }

  const [showAddTarget, setShowAddTarget] = useState(false)

  const [targets, setTargets] = useState([])

  // Use effects to get targets
  useEffect(() => {
    const getTargets = async() => {
      const targetsFromServer = await fetchTargets()
      setTargets(targetsFromServer)
    }
    getTargets()
  }, [])

  // Get targets from imitation JSON db
  const fetchTargets = async () => {
    try{
    const res = await fetch('http://localhost:5000/targets')
    const data = await res.json()
    return data
    }
    catch(ex)
    {
      alert("Unable to connect to DB")
      return []
    }
  }

  // Create a target
  const createTarget = async (target) => {
    const res = await fetch('http://localhost:5000/targets', {
      method: 'POST',
      headers: {
        'Content-type': 'application/json'
      },
      body: JSON.stringify(target)
    })

    const data = await res.json()

    setTargets([...targets, data])
    //console.log(task)
    //alert(JSON.stringify(data))
  }

  // Delete Target (id passed up from clicked target)
  const deleteTarget = async (id) => {
    
    const res = await fetch(`http://localhost:5000/targets/${id}`, {
      method: 'DELETE',
    })

    // Check if target was deleted. If not, alert the user
    res.status === 200
    ? setTargets(targets.filter((target) => target.id !== id))
    : alert('Error Delerting Target')
  }

  // Function to generate JSON file from DB
  async function generateTargetFile(){
    const res = await fetch('http://localhost:5000/targets')
    const data = await res.json()

    var filename = 'targets.json'

    var content = JSON.stringify(data)
    //alert(content)

    var file = new Blob([content], { type: "application/json" });
    if (window.navigator.msSaveOrOpenBlob) // IE10+
        window.navigator.msSaveOrOpenBlob(file, filename);
    else { // Others
        var a = document.createElement("a"),
                url = URL.createObjectURL(file);
        a.href = url;
        a.download = filename;
        document.body.appendChild(a);
        a.click();
        setTimeout(function() {
            document.body.removeChild(a);
            window.URL.revokeObjectURL(url);  
        }, 0); 
    }  
  }

  function generateSampleFile(){
    alert('Implementing Soon')
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
            <Header onAdd={() => setShowAddTarget(!showAddTarget)}
              showAddTarget={showAddTarget}
              generateFile={() => generateTargetFile()}
              generateSample={() => generateSampleFile()} />
            <section className="section-left">
              {showAddTarget && <CreateTarget createTarget={createTarget} />}
            </section>
            <section className="section-right">
              {targets.length > 0 ?
                (<Targets targets={targets} onDelete={deleteTarget} />) :
                ('No Targets To Show')}
            </section>
          </section>
        </section>

      </missionplanning>

      <Inventory />
    </div>
  );
}

export default App;
