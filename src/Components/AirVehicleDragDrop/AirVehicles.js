/*Set of Air Vehicles with Deag Drop Functionality*/

// Components for click and drag Aircraft selections
import Board from './Board';
import Card from "./Card";
import Aircraft from "./Aircraft";
import Growler from '../../AircraftImages/Growler.png';
import FA18F from '../../AircraftImages/FA-18A.png';
import F35 from '../../AircraftImages/F35.png';
import B2 from '../../AircraftImages/B2.png';
import AH64 from '../../AircraftImages/AH-64.png';


const AirVehicles = () => {
    return (
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
          <Aircraft aircraftName='AH64 (Apache)' image={AH64} />
        </Card>
        <Card id="Aircraft-4" className="aircraft" draggable="true">
          <Aircraft aircraftName='F35' image={F35} />
        </Card>
        <Card id="Aircraft-5" className="aircraft" draggable="true">
          <Aircraft aircraftName='B2' image={B2} />
        </Card>
      </Board>
      <Board id="board-2" className="board">
        <center><h3>Mission</h3></center>
      </Board>
    </main>
    )
}

export default AirVehicles