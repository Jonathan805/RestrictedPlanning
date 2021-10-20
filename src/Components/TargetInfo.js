import React, { Component } from 'react'
import Container from 'react-bootstrap/esm/Container';
import Row from 'react-bootstrap/esm/Row';
import Col from 'react-bootstrap/esm/Col';
import Button from 'react-bootstrap/Button'
import PopoverWrapper from './PopoverWrapper';
import TimeLine from 'react-gantt-timeline';
import Generator from './Borrowed/Generator';
import ObjectHelper from './Borrowed/ObjectHelper';

class TargetInfo extends Component{
  constructor(props) {
    super(props);
    this.target = props.target;
    this.data = [{
      id: ObjectHelper.genID(),
      start: new Date(),
      end: this.getRandomDate(),
      name: 'New Task',
      color: this.getRandomColor()
    },
    {
      id: ObjectHelper.genID(),
      start: new Date(),
      end: this.getRandomDate(),
      name: 'New Task',
      color: this.getRandomColor()
    }]
    this.state = {
      itemheight: 20,
      data: [],
      selectedItem: null,
      timelineMode: 'week',
      links: null,
      nonEditableName: false
    };
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
    this.setState({ data: [...this.state.data] });
    console.log(`Update Item ${item}`);
  };

  onCreateLink = (item) => {
    let newLink = Generator.createLink(item.start, item.end);
    this.setState({ links: [...this.state.links, newLink] });
    console.log(`Update Item ${item}`);
  };

  getbuttonStyle(value) {
    return this.state.timelineMode == value ? { backgroundColor: 'grey', boder: 'solid 1px #223344' } : {};
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

  getRandomColor() {
    var letters = '0123456789ABCDEF';
    var color = '#';
    for (var i = 0; i < 6; i++) {
      color += letters[Math.floor(Math.random() * 16)];
    }
    return color;
  }

  addTask = () => {
    let newTask = {
      id: this.state.data.length + 1,
      start: new Date(),
      end: this.getRandomDate(),
      name: 'New Task',
      color: this.getRandomColor()
    };
    this.setState({ data: [newTask, ...this.state.data] });
  };

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
          showLabel:false,//If the task display the a lable
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
        <Container>
          <Row>
            <h3>{this.target.targetName} </h3>
          </Row>
          <Row>
          <Row>Latitude: {this.target.latitude} </Row>
          <Row>Longitude: {this.target.longitude} </Row>
          <Row>Elevation: {this.target.elevation} </Row>
          </Row>
          <Row>
            <Col>
              <PopoverWrapper name={this.target.targetName} 
                              imagery={this.target.targetImage} 
                              buttonText="See Imagery"/>
            </Col>
            <Col>
              <Button>Generate Route</Button>
            </Col>
          </Row>
          <Row>
          <TimeLine
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
          </Row>
        </Container>
      </div>
    );
  }
}

export default TargetInfo