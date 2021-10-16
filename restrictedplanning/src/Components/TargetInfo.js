import React, { Component } from 'react'
import Container from 'react-bootstrap/esm/Container';
import Row from 'react-bootstrap/esm/Row';
import Col from 'react-bootstrap/esm/Col';
import PopoverWrapper from './PopoverWrapper';

class TargetInfo extends Component{
  constructor(props) {
    super(props);
    this.targetImage = props.targetImage;
    this.targetName = props.targetName;
    this.latitude = props.latitude;
    this.longitude = props.longitude;
    this.elevation = props.elevation;
  }

  render() {
    return (
      <div>
        <Container>
          <Row>
            <h3>{this.targetName} </h3>
          </Row>
          <Row>
            <Col>Latitude: {this.latitude} </Col>
            <Col>Longitude: {this.longitude} </Col>
            <Col>Elevation: {this.elevation} </Col>
          </Row>
          <Row>
            <Col>
            <PopoverWrapper name={this.targetName} 
                            imagery={this.targetImage} 
                            buttonText="See Imagery"/>
            </Col>
            <Col>
            <PopoverWrapper name={this.targetName} 
                            imagery={this.targetImage} 
                            buttonText="See Weather"/>
              </Col>
          </Row>
        </Container>
      </div>
    );
  }
}

export default TargetInfo