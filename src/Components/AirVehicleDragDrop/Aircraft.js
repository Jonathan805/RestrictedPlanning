/*Aircraft object placed in card*/

//import { propTypes } from "react-bootstrap/esm/Image"

const Aircraft = ({aircraftName, image}) => {
    return (
        <p>{aircraftName}
        <br></br><img src={image} alt={aircraftName} />
          <select name="count" id="count">
            <option value="1">1</option>
            <option value="2">2</option>
            <option value="3">3</option>
            <option value="4">4</option>
            <option value="5">5</option>
            <option value="6">6</option>
            <option value="7">7</option>
          </select>
        </p>
    )
}

Aircraft.defaultProps = {
    aircraftName: 'Airplane'
}

/*
Aircraft.propTypes = {
    aircraftName: propTypes.string.isRequired,
    image: propTypes.string.isRequired
}
*/

export default Aircraft