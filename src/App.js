import React, { Component } from "react"
import './App.css';
import Nav from "./Components/Navbar";
import Inventory from "./Components/Inventory";
import 'bootstrap/dist/css/bootstrap.css'
import Row from "react-bootstrap/Row"
import TargetList from "./Components/TargetList";

// Toast components
import Toast from "./Components/ToastMessage";

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

import {toast} from 'react-toastify'
import 'react-toastify/dist/ReactToastify.css'

toast.configure()

const App = () => {

  // Toast stuff
  const [list, setList] = useState([]);

  const [showAddTarget, setShowAddTarget] = useState(false)

  const [targets, setTargets] = useState([])

  // TODO: Need to define constants for notifications and use
  // them when actions are performed
  const notify = () => {
    toast('Basic notification!')
  }

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
      toast('NOTICE! --> Unable to Connect to DB')
      toast('Execute "npm run server" locally to start JSON Server')
      //alert("Unable to connect to DB")
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
    toast('Target Created')
    //console.log(task)
    //alert(JSON.stringify(data))
  }

  const showToast = (title, message) => {
    const id = Math.floor((Math.random() * 101) + 1);
    let toastProperties;
    toastProperties = {
      id,
      title: title,
      description: message,
      backgroundColor: '#5cb85c'
    }
    setList([...list, toastProperties]);
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

    toast('Target Deleted')
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
              <TargetList toastHandler={showToast}/>
            </Row>
          </section>
          <br />
          <section className="section-top">
            <Header onAdd={() => setShowAddTarget(!showAddTarget)}
              showAddTarget={showAddTarget}
              generateFile={() => generateTargetFile()}
              generateSample={() => generateSampleFile()}/> <br/>
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
      <Toast 
        toastList={list}
        position={"bottom-right"}
        autoDelete={false}
        autoDeleteTime={300}
      />
    </div>
  );
}

export default App;
