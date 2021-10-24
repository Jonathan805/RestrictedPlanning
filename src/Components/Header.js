import PropTypes from 'prop-types'
import Button from './Button'

const Header = ({ title }) => {

    const onClick = () => {
        console.log('object')
    }

  return (
    <header className='header'>
      <h1 style={{color: 'Black', backgroundColor:'lightblue'}}>{title}</h1>
      <Button backColor='green' text='Add' onClick={onClick}/>
    </header>
  )
}

Header.defaultProps = {
  title: 'Targets',
}

Header.propTypes = {
  title: PropTypes.string.isRequired,
}

export default Header