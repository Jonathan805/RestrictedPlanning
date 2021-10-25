import {FaTimes} from 'react-icons/fa'

const Target = ({target, onDelete}) => {
    return (
        <div className='target'>
            <h3>{target.name} 
            <FaTimes 
            style={{color:'red', cursor:'pointer'}}
            onClick={() => onDelete(target.id)} // pass the id when delete clicked
            />
            </h3>
            <p>Lat:{target.latitude} Lon:{target.longitude} Elevation:{target.elevation} SuccessRate:{target.successRate}</p>
        </div>
    )
}


export default Target