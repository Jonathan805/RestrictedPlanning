import React, { Component } from "react"
import './App.css';
import Nav from "./Components/Navbar";
import Inventory from "./Components/Inventory";
import 'bootstrap/dist/css/bootstrap.css'
import Row from "react-bootstrap/Row"
import TargetList from "./Components/TargetList";

// Drag and Drop Air Vehicles
import AirVehicles from './Components/AirVehicleDragDrop/AirVehicles';

// Target Creator 
import TargetCreator from './Components/TargetForm/TargetCreator';

// Import for Toast
import {toast} from 'react-toastify'
import 'react-toastify/dist/ReactToastify.css'

toast.configure()

const App = () => {

  return (
    <div>
      <Nav />
      <section id="section-left">
        <AirVehicles/>
      </section>
      <missionplanning className="missionfunctions">
      <section className="section-right">
          <section className="section-top">
              
            <TargetCreator/>
          </section>
          <TargetList/>
      </section>
      </missionplanning>

      <Inventory />
    </div>
  );
}

export default App;
