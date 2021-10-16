import React, {Component} from 'react';
import Popover from 'react-bootstrap/Popover'
import Button from 'react-bootstrap/Button'
import OverlayTrigger from 'react-bootstrap/OverlayTrigger'

class PopoverWrapper extends Component{

  constructor(props){
    super(props);
    this.name = props.name;
    this.imagery = props.imagery;
    this.buttonText = props.buttonText;
  }

 

  render()  {

    var popup = (
      <Popover id="popover-basic">
      <Popover.Header as="h3">Image of {this.name}</Popover.Header>
      <Popover.Body>
        <img src={this.imagery} alt="sample text" max-width="100%" max-height="100%" object-fit="cover"/>
      </Popover.Body>
    </Popover>
      );

    return (      
    <OverlayTrigger trigger="click" placement="right" overlay={popup}>
      <Button variant="success">
        {this.buttonText}
      </Button>
  </OverlayTrigger>);
  }
}

export default PopoverWrapper