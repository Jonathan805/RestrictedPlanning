/*Contians targets saved in db */

import Target from './Target'

const Targets = ({targets, onDelete}) => {
    return (
        <>
            {targets.map((target, index) => (
                <Target key={index} target={target}
                onDelete={onDelete}/>
            ))}
        </>
    )
}

export default Targets