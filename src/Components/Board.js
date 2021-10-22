/*
Class represents a Board object to contain draggable items
*/

import React from 'react'

function Board(props) {

    const drop = e => {
        e.preventDefault();
        // transfer the id for event
        const card_id = e.dataTransfer.getData('card_id');

        // get the element
        const card = document.getElementById(card_id);
        card.style.display = 'block';
 
        // append to board
        e.target.appendChild(card);
    }

    const dragOver = e => {
        e.preventDefault();
    }

    return(
    <div 
    id ={props.id}
    className={props.className}
    onDrop={drop}
    onDragOver={dragOver}>
        { props.children }
    </div>
    ) 
}

export default Board

