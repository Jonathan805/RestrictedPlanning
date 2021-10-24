import React, { Component } from 'react'
import { Toast } from 'react-bootstrap'
import { ToastContainer } from 'react-bootstrap';
class ToastMessage extends Component{

  constructor(props)  {
    super(props)
    this.state = [{show: false}];
    this.message = this.props.message;
    this.description = this.props.description;
  }

  closeToast = () => {
    this.setState({show: false});
  }

  showMessage = (message, description) => {
    this.setState({show:true});
    this.message = message;
    this.description = description;
  }

  render() {
    return(
      <ToastContainer position='bottom-right'>
        <Toast show={this.state.show} onClose={this.closeToast} delay={3000} autohide>
          <Toast.Header>
            <strong className="me-auto">{this.props.target}</strong>
            <small>{this.message}</small>
          </Toast.Header>
          <Toast.Body>{this.description}</Toast.Body>
        </Toast>
    </ToastContainer>
    );
  }
}

export default ToastMessage