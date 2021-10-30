import React, { Component } from 'react'
import DragAndDrop from './DragAndDrop'
import TargetInfo from './TargetInfo'
import {TargetClass} from '../Classes/TargetClass';

class TargetList extends Component {
state = {
    targets: []
  }

 handleDrop = (targetsFile) => {
    let targets = this.state.targets
    for (var i = 0; i < targetsFile.length; i++) {
      if (!targetsFile[i].name) return
      var reader = new FileReader();
      reader.onload = function(e) {
        let  content = e.target.result;
        let tempTargets = JSON.parse(content)
        tempTargets.map((target) =>  targets.push(new TargetClass(target.image, 
                                                             target.name, 
                                                             target.latitude, 
                                                             target.longitude, 
                                                             target.elevation, 
                                                             target.successChance, 
                                                             target.sorties)));   
      }
       reader.readAsText(targetsFile[i])
    }
     this.setState({targets: targets} )
  }

render() {
    return(
      <span class="border">
      <DragAndDrop handleDrop={this.handleDrop} displayText={"Drag ATO here"}>
        <div style={{height: 300, width: 1200}}>
          {this.state.targets.map((target) =>
              <TargetInfo target={target} toastHandler={this.props.toastHandler}/>         
          )}
        </div>
      </DragAndDrop>
      </span>
    )
  }
}
export default TargetList