/* Form utilized to create targets*/

const CreateTarget = () => {
    return (
        <form class-Name='create-target'>
            <div clasName='form-control'>
                <label>Name</label>
                <br/>
                <input type='text' placeholder='Add Name'/>
            </div>
            <div clasName='form-control'>
                <label>Lattitude</label>
                <br/>
                <input type='text' placeholder='21°21 44.9\"N'/>
            </div>
            <div clasName='form-control'>
                <label>Longitude</label>
                <br/>
                <input type='text' placeholder='157°57 12.6\"W'/>
            </div>
            <div clasName='form-control'>
                <label>Elevation</label>
                <br/>
                <input type='text' placeholder='0 MSL'/>
            </div>
            <div clasName='form-control'>
                <label>Success Rate (Auto-Calc later)</label>
                <br/>
                <input type='text' placeholder='0.75'/>
            </div>
            <br/>
            <input type='submit' value='Create Target'
            color='white' background-color='#4CAF50'/>
        </form>
    )
}

export default CreateTarget