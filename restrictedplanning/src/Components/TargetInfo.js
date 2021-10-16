import React, { Component } from 'react'
import Popover from 'react-bootstrap/Popover'
import Button from 'react-bootstrap/Button'
import OverlayTrigger from 'react-bootstrap/OverlayTrigger'

class TargetInfo extends Component{
  constructor(props) {
    super(props);
    this.image = props.image;
    this.name = props.name
  }

  render() {
    var popup = (
      <Popover id="popover-basic">
      <Popover.Header as="h3">Image of {this.name}</Popover.Header>
      <Popover.Body>
        <img src={this.image} alt="sample text" max-width="100%" max-height="100%"/>
      </Popover.Body>
    </Popover>
      );

    return (
      <div>
        <div class="TargetName">
          <h1>{this.name} </h1>
        </div>
        
      <OverlayTrigger trigger="click" placement="right" overlay={popup}>
        <Button variant="success">
          See imagery
        </Button>
      </OverlayTrigger>
      </div>
    );
  }
}

export default TargetInfo