import React, { Component } from 'react'
import NavDropdown from 'react-bootstrap/NavDropdown'

class HoverDropdown extends Component{
  constructor(props){
    super(props);
    this.state = {isOpen: false}
  }

  handleOpen = ()  => {
    this.setState({isOpen:true})
  }
  handleClose = ()  => {
    this.setState({isOpen:false})
  }

  render()  {
    return (
    <NavDropdown {...this.props}
                 onMouseEnter={this.handleOpen}
                 onMouseLeave={this.handleClose}
                 show={this.state.isOpen}>
      {this.props.children}
    </NavDropdown>
    );
  }
}

export default HoverDropdown
