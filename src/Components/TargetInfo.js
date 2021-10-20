import React, { Component } from 'react'
import Container from 'react-bootstrap/esm/Container';
import Row from 'react-bootstrap/esm/Row';
import Col from 'react-bootstrap/esm/Col';
import Button from 'react-bootstrap/Button'
import PopoverWrapper from './PopoverWrapper';
import TimeLine from 'react-gantt-timeline';
import Generator from './Borrowed/Generator';

class TargetInfo extends Component{
  constructor(props) {
    super(props);
    this.target = props.target;
    let result = Generator.generateData();
    this.data = result.data;
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
    result.setDate(result.getDate() + Math.random() * 10);
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

  delete = () => {
    console.log('On delete');
    if (this.state.selectedItem) {
      let index = this.state.links.indexOf(this.state.selectedItem);
      if (index > -1) {
        this.state.links.splice(index, 1);
        this.setState({ links: [...this.state.links] });
      }
      index = this.state.data.indexOf(this.state.selectedItem);
      if (index > -1) {
        this.state.data.splice(index, 1);
        this.setState({ data: [...this.state.data] });
      }
    }
  };

  addTask = () =>{

  }

  render() {
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
            // config={config}
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