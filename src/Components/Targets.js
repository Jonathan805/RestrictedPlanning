/*Contians targets saved in db */

import Target from './Target'

const Targets = ({targets, onDelete}) => {
    return (
        <>
            {targets.map((target) => (
                <Target key={target.id} target={target}
                onDelete={onDelete}/>
            ))}
        </>
    )
}

export default Targets