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
      var content = reader.readAsText(targetsFile[i])
      window.alert(content);
      targets = JSON.parse(content);
      window.alert(targets);
    }
    window.alert("Updating the object")
    this.setState({targets: targets})
  }
render() {
    return (

      <DragAndDrop handleDrop={this.handleDrop}>
        <div style={{height: 300, width: 250}}>
        <span class="border border-primary">
          {this.state.targets.map((target) =>
              <TargetInfo name={target.name}
                          image={target.image}
                          latitude={target.latitude}
                          longitude={target.longitude}
                          elevation={target.elevation}/>         
          )}
          </span>
        </div>
      </DragAndDrop>
    )
  }
}
export default TargetList