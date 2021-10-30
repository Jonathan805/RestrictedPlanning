/* Form utilized to manually create targets*/

import { useState } from 'react'

const CreateTarget = ({createTarget}) => {

    const [name, setName] = useState('')
    const [latitude, setLatitude] = useState('')
    const [longitude, setLongitude] = useState('')
    const [elevation, setElevation] = useState('')
    const [successRate, setSuccessRate] = useState('')

    const onSubmit = (e) => {
        e.preventDefault()
        if(!name){
            alert('Please add a name')
            return
        }
        if(!latitude){
            alert('Please add a latitude')
            return
        }
        if(!longitude){
            alert('Please add a longitude')
            return
        }
        if(!elevation){
            alert('Please add a elevation')
            return
        }
        if(!successRate){
            alert('Please add a successRate')
            return
        }

        createTarget({name, latitude, longitude, elevation, successRate})

        setName('')
        setLatitude('')
        setLongitude('')
        setElevation('')
        setSuccessRate('')
    }

    return (
        <form className='create-target' onSubmit={onSubmit} class='form-control'>
            <div clasName='form-control'>
                <label>Name</label>
                <br/>
                <input type='text' 
                placeholder='Add Name' 
                value={name} 
                onChange={(e) => setName(e.target.value)}/>
            </div>
            <div clasName='form-control'>
                <label>Lattitude</label>
                <br/>
                <input type='text' 
                placeholder='ex. 21°21 44.9\"N'
                value={latitude} 
                onChange={(e) => setLatitude(e.target.value)}/>
            </div>
            <div clasName='form-control'>
                <label>Longitude</label>
                <br/>
                <input type='text' 
                placeholder='ex. 21°21 44.9\"N'
                value={longitude} 
                onChange={(e) => setLongitude(e.target.value)}/>
            </div>
            <div clasName='form-control'>
                <label>Elevation</label>
                <br/>
                <input type='text' placeholder='ex. 0 MSL'
                value={elevation} 
                onChange={(e) => setElevation(e.target.value)}/>
            </div>
            <div clasName='form-control'>
                <label>Success Rate (Auto-Calc later)</label>
                <br/>
                <input type='text' placeholder='ex. 0.75'
                value={successRate} 
                onChange={(e) => setSuccessRate(e.target.value)}/>
            </div>
            <br/>
            <input type='submit' value='Create Target'
            color='white' background-color='#4CAF50'/>
        </form>
    )
}

export default CreateTarget