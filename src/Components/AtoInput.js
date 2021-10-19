import React, { Component } from 'react'


//inspiration: https://medium.com/@650egor/simple-drag-and-drop-file-upload-in-react-2cb409d88929
class AtoInput extends Component{

  dropRef = React.createRef()

  handleDrag = (e) => {
    e.preventDefault()
    e.stopPropagation()
  }
  handleDragIn = (e) => {
    e.preventDefault()
    e.stopPropagation()
  }
  handleDragOut = (e) => {
    e.preventDefault()
    e.stopPropagation()
  }
  handleDrop = (e) => {    
    e.preventDefault()
    e.stopPropagation()
  }

  componentDidMount() {
    let div = this.dropRef.current
    div.addEventListener('dragenter', this.handleDragIn)
    div.addEventListener('dragleave', this.handleDragOut)
    div.addEventListener('dragover', this.handleDrag)
    div.addEventListener('drop', this.handleDrop)
  }

  componentWillUnmount() {
    let div = this.dropRef.current
    div.removeEventListener('dragenter', this.handleDragIn)
    div.removeEventListener('dragleave', this.handleDragOut)
    div.removeEventListener('dragover', this.handleDrag)
    div.removeEventListener('drop', this.handleDrop)
  }

  render() {
    return(
    <div ref={this.dropRef}>
      {this.props.children}
    </div>)
  }
};

export default AtoInput