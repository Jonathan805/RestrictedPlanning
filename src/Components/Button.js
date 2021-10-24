import PropTypes from 'prop-types'

const Button = ({ backColor, text, onClick }) => {
  return (
    <button
      onClick={onClick}
      style={{ backgroundColor: backColor, color:'white', fontSize:20}}>
      {text}
    </button>
  )
}

Button.defaultProps = {
  backColor: 'steelblue',
}

Button.propTypes = {
  text: PropTypes.string,
  backColor: PropTypes.string,
  onClick: PropTypes.func.isRequired
}

export default Button