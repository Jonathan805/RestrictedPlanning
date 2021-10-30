import PropTypes from 'prop-types'
import Button from './Button'

const Header = ({ title, onAdd, showAddTarget, generateFile, generateSample}) => {

  return (
    <header className='header'>
      <h1 style={{color: 'Black', backgroundColor:'lightGreen'}}>{title}</h1>
      <Button backColor={showAddTarget ? 'red' : 'green'} 
      text={showAddTarget ? 'Close' : 'Create New Target'} 
      onClick={onAdd}/>
      <Button backColor='Blue'
      text='Generate Targets File'
      onClick={generateFile}/>
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