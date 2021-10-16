import React, { Component } from 'react'

class AtoInput extends Component{

  dropRef = React.createRef()

  componentDidMount(){
    let div = this.dropRef.current
  }

  componentWillUnmount(){

  }

  render() {
    return
    <div ref={this.dropRef}>
      {this.props.children}
    </div>
  }
};

export default AtoInput