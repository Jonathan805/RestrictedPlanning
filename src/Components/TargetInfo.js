import React, { Component } from 'react'
import Button from 'react-bootstrap/Button'
import PopoverWrapper from './PopoverWrapper';
import Generator from './Borrowed/Generator';
import TimeLine2 from './CustomTimeline/TimeLine'

class TargetInfo extends Component{
  constructor(props) {
    super(props);
    this.state = {
      itemheight: 20,
      data: [],
      selectedItem: null,
      timelineMode: 'week',
      links: [],
      nonEditableName: true
    };

    this.target = props.target;
    this.sorties = props.target.sorties;
    this.data = [];
    // Create timeline data from the sortie data in JSON
    this.sorties.map((sortie, index) => 
      this.data.push(
        {
          id: index,
          start: new Date(sortie.startTime),
          end:  new Date(sortie.endTime),
          restEnd: new Date(sortie.restEndTime),
          name: sortie.tail,
          color: this.getPurpleColor(),
          color2: this.getRestColor()
        }
      )// end push
    )// end map
  } 
  
  handleDayWidth = (e) => {
    this.setState({ daysWidth: parseInt(e.target.value) });
  };
  
  handleItemHeight = (e) => {
    this.setState({ itemheight: parseInt(e.target.value) });
  };
  
  onHorizonChange = (start, end) => {
    let result = this.data.filter((item) => {
      return (item.start < start && item.end > end) || (item.start > start && item.start < end) || (item.end > start && item.end < end);
    });
    console.log('Calculating ');
    this.setState({ data: result });
  };
  
  onSelectItem = (item) => {
    console.log(`Select Item ${item}`);
    this.setState({ selectedItem: item });
  };
  
  onUpdateTask = (item, props) => {
    item.start = props.start;
    item.end = props.end;
    let difference = (item.end - item.start) / 1000 / 60 / 60;
    if (difference > 4){
      item.color = this.getRedColor();
    }
    else{
      item.color = this.getPurpleColor();
    }   
    this.setState({ data: [...this.state.data] });
  };

  shiftItems = () => {

  }
  
  onCreateLink = (item) => {
    let newLink = Generator.createLink(item.start, item.end);
    this.setState({ links: [...this.state.links, newLink] });
    console.log(`Update Item ${item}`);
  };
  
  getbuttonStyle(value) {
    return this.state.timelineMode === value ? { backgroundColor: 'grey', boder: 'solid 1px #223344' } : {};
  }
  
  modeChange = (value) => {
    this.setState({ timelineMode: value });
  };
  
  genID() {
    function S4() {
      return (((1 + Math.random()) * 0x10000) | 0).toString(16).substring(1);
    }
    return (S4() + S4() + '-' + S4() + '-4' + S4().substr(0, 3) + '-' + S4() + '-' + S4() + S4() + S4()).toLowerCase();
  }
  
  getRandomDate() {
    let result = new Date();
    result.setHours(result.getHours() + 4);
    return result;
  }

  getRedColor(){
    return "#FF0000";
  }

  getPurpleColor()  {
    return 	"#4B0082";
  }

  getRestColor(){
    return "#FFD700";
  }

   
  render() {
    let config = {
      header:{ //Targert the time header containing the information month/day of the week, day and time.
        top:{//Tartget the month elements
          style:{backgroundColor:"#333333"} //The style applied to the month elements
        },
        middle:{//Tartget elements displaying the day of week info
          style:{backgroundColor:"chocolate"}, //The style applied to the day of week elements
          selectedStyle:{backgroundColor:"#b13525"}//The style applied to the day of week elements when is selected
        },
        bottom:{//Tartget elements displaying the day number or time 
          style:{background:"grey",fontSize:9},//the style tp be applied 
          selectedStyle:{backgroundColor:"#b13525",fontWeight:  'bold'}//the style tp be applied  when selected
        }
      },
      taskList:{//the right side task list
        title:{//The title od the task list
          label:"Sorties",//The caption to display as title
          style:{backgroundColor:  '#333333',borderBottom:  'solid 1px silver',
          color:  'white',textAlign:  'center'}//The style to be applied to the title
        },
        task:{// The items inside the list diplaying the task
          style:{backgroundColor:  '#fbf9f9'}// the style to be applied
        },
        verticalSeparator:{//the vertical seperator use to resize he width of the task list
          style:{backgroundColor:  '#333333',},//the style
          grip:{//the four square grip inside the vertical separator
            style:{backgroundColor:  '#cfcfcd'}//the style to be applied
          }
        }
      },
      dataViewPort:{//The are where we display the task
        rows:{//the row constainting a task
          style:{backgroundColor:"#fbf9f9",borderBottom:'solid 0.5px #cfcfcd'}
        },
        task:{//the task itself
          showLabel:true,//If the task display the a lable
          style:{position:  'absolute',borderRadius:14,color:  'white',
          textAlign:'center',backgroundColor:'grey'},
          selectedStyle:{}//the style tp be applied  when selected
        }
      },
      links:{//The link between two task
        color:'black',
        selectedColor:'#ff00fa'
      }
    }
    return (
      <div>
        {/* title row*/}
        <div className="targetTitle">
          <h3>{this.target.targetName} </h3>
        </div>
      <div className="targetRow">
        <div className="timeline">
        <TimeLine2
              config={config}
              data={this.state.data}
              links={this.state.links}
              onHorizonChange={this.onHorizonChange}
              onSelectItem={this.onSelectItem}
              onUpdateTask={this.onUpdateTask}
              onCreateLink={this.onCreateLink}
              mode={this.state.timelineMode}
              itemheight={this.state.itemheight}
              selectedItem={this.state.selectedItem}
              nonEditableName={this.state.nonEditableName}
              /> 
          </div>              
        <div>
          <p>Latitude: {this.target.latitude} </p>
          <p>Longitude: {this.target.longitude} </p>
          <p>Elevation: {this.target.elevation} </p>
          <p>Chance of success: {this.target.successChance}</p>
        </div>
        <div>
          <PopoverWrapper name={this.target.targetName} 
                                    imagery={this.target.targetImage} 
                                    buttonText="See Imagery"/>
        </div>
        <div><Button>Generate Route</Button></div>
      </div>
      </div>
      );
    }
  }
  
  export default TargetInfo