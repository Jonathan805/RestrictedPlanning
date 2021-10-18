import React, { Component } from 'react'
import DragAndDrop from './DragAndDrop'
import TargetInfo from './TargetInfo'

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
        tempTargets.map((target) => targets.push(target));   
      }
       reader.readAsText(targetsFile[i])
    }
    this.setState({targets: targets})
  }
render() {
    return(
      <span class="border">
      <DragAndDrop handleDrop={this.handleDrop} displayText={"Drag target list here"}>
        <div style={{height: 300, width: 1000}}>
          {this.state.targets.map((target) =>
              <TargetInfo name={target.name}
                          image={target.image}
                          latitude={target.latitude}
                          longitude={target.longitude}
                          elevation={target.elevation}/>         
          )}
        </div>
      </DragAndDrop>
      </span>
    )
  }
}
export default TargetList