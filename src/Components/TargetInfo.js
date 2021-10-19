import React, { Component } from 'react'
import Container from 'react-bootstrap/esm/Container';
import Row from 'react-bootstrap/esm/Row';
import Col from 'react-bootstrap/esm/Col';
import Button from 'react-bootstrap/Button'
import PopoverWrapper from './PopoverWrapper';

class TargetInfo extends Component{
  constructor(props) {
    super(props);
    this.target = props.target;
  }

  render() {
    return (
      <div>
        <Container>
          <Row>
            <h3>{this.target.targetName} </h3>
          </Row>
          <Row>
            <Col>Latitude: {this.target.latitude} </Col>
            <Col>Longitude: {this.target.longitude} </Col>
            <Col>Elevation: {this.target.elevation} </Col>
          </Row>
          <Row>
            <Col>
              <PopoverWrapper name={this.target.targetName} 
                              imagery={this.target.targetImage} 
                              buttonText="See Imagery"/>
            </Col>
            <Col>
              <PopoverWrapper name={this.target.targetName} 
                              imagery={this.target.targetImage} 
                              buttonText="See Weather"/>
            </Col>
            <Col>
              <Button>Generate Route</Button>
            </Col>
          </Row>
        </Container>
      </div>
    );
  }
}

export default TargetInfo