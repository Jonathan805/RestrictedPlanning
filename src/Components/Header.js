import PropTypes from 'prop-types'
import Button from './Button'

const Header = ({ title, onAdd, showAddTarget}) => {

  return (
    <header className='header'>
      <h1 style={{color: 'Black', backgroundColor:'lightGreen'}}>{title}</h1>
      <Button backColor={showAddTarget ? 'red' : 'green'} 
      text={showAddTarget ? 'Close Create Target' : 'Create New Target'} 
      onClick={onAdd}/>
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