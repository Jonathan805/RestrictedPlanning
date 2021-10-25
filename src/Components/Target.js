import {FaTimes} from 'react-icons/fa'

const Target = ({target}) => {
    return (
        <div className='target'>
            <h3>{target.name} <FaTimes/></h3>
            <p>Lat:{target.latitude} Lon:{target.longitude} Elevation:{target.elevation} SuccessRate:{target.successRate}</p>
        </div>
    )
}


export default Target