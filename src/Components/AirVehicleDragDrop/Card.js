/*
Class represents a Card (AirVehicle) object that are draggable items
*/

import React from 'react'

function Card(props) {

    const dragStart = e => {
        const target = e.target;
        e.dataTransfer.setData('card_id', target.id);

        // Allow for entire card to be moved with mouse 
        setTimeout(() => {
            target.style.display = "none";
        }, 0);
    }

    const dragOver = e => {
        e.stopPropagation();
    }

    return (
        <div
            id={props.id}
            clasName={props.clasName}
            draggable={props.draggable}
            onDragStart={dragStart}
            onDragOver={dragOver}>
            {props.children}
        </div>
    )
}

export default Card