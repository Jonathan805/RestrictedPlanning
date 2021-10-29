/* Return entire form and buttons for target creation functionality */

// Components for creating Targets
import Header from './Header';
import Targets from './Targets';
import CreateTarget from './CreateTarget';
import { useState, useEffect } from 'react'

// Import for Toast
import {toast} from 'react-toastify'
import 'react-toastify/dist/ReactToastify.css'

toast.configure()

const TargetCreator = () => {
  
    const [showAddTarget, setShowAddTarget] = useState(false)

    const [targets, setTargets] = useState([])
  
    // Use effects to get targets
    useEffect(() => {
      const getTargets = async() => {
        const targetsFromServer = await fetchTargets()
        setTargets(targetsFromServer)
      }
      getTargets()
    }, [])
  
    // Get targets from imitation JSON db
    const fetchTargets = async () => {
      try{
      const res = await fetch('http://localhost:5000/targets')
      const data = await res.json()
      return data
      }
      catch(ex)
      {
        toast('NOTICE! --> Unable to Connect to DB')
        toast('Execute "npm run server" locally to start JSON Server')
        //alert("Unable to connect to DB")
        return []
      }
    }
  
    // Create a target
    const createTarget = async (target) => {
      const res = await fetch('http://localhost:5000/targets', {
        method: 'POST',
        headers: {
          'Content-type': 'application/json'
        },
        body: JSON.stringify(target)
      })
  
      const data = await res.json()
  
      setTargets([...targets, data])
      toast('Target Created')
      //console.log(task)
      //alert(JSON.stringify(data))
    }
  
  
    // Delete Target (id passed up from clicked target)
    const deleteTarget = async (id) => {
      
      const res = await fetch(`http://localhost:5000/targets/${id}`, {
        method: 'DELETE',
      })
  
      // Check if target was deleted. If not, alert the user
      res.status === 200
      ? setTargets(targets.filter((target) => target.id !== id))
      : alert('Error Delerting Target')
  
      toast('Target Deleted')
    }
  
    // Function to generate JSON file from DB
    async function generateTargetFile(){
      const res = await fetch('http://localhost:5000/targets')
      const data = await res.json()
  
      var filename = 'targets.json'
  
      var content = JSON.stringify(data)
      //alert(content)
  
      var file = new Blob([content], { type: "application/json" });
      if (window.navigator.msSaveOrOpenBlob) // IE10+
          window.navigator.msSaveOrOpenBlob(file, filename);
      else { // Others
          var a = document.createElement("a"),
                  url = URL.createObjectURL(file);
          a.href = url;
          a.download = filename;
          document.body.appendChild(a);
          a.click();
          setTimeout(function() {
              document.body.removeChild(a);
              window.URL.revokeObjectURL(url);  
          }, 0); 
      }  
    }
  
    function generateSampleFile(){
      alert('Implementing Soon')
    }

    return (
          <section className="section-top">
            <Header onAdd={() => setShowAddTarget(!showAddTarget)}
              showAddTarget={showAddTarget}
              generateFile={() => generateTargetFile()}
              generateSample={() => generateSampleFile()}/> <br/>
            <section className="section-left">
              {showAddTarget && <CreateTarget createTarget={createTarget} />}
            </section>
            <section className="section-right">
              {targets.length > 0 ?
                (<Targets targets={targets} onDelete={deleteTarget} />) :
                ('No Targets To Show')}
            </section>
        </section>
    )
}

export default TargetCreator