/*Contians targets saved in db */

import Target from './Target'

const Targets = ({targets}) => {
    return (
        <>
            {targets.map((target) => (
                <Target key={target.id} target={target}/>
            ))}
        </>
    )
}

export default Targets