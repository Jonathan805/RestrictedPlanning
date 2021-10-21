import React from "react";
import { Toast } from "react-bootstrap";

function CustomToast(message, date){
  return(
    <Toast delay={3000}>
      <Toast.Header>
        <strong className="me-auto">New Event</strong>
        <small>{(new Date() - date)/1000 } seconds ago</small>
      </Toast.Header>
      <Toast.Body>{message}</Toast.Body>
    </Toast>
  );
}

export default CustomToast;