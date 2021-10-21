import React, { Component } from "react";
import { ComposableMap, Geographies, Geography } from "react-simple-maps";

class Map extends Component{
  render(){
    const geoUrl =
  "https://raw.githubusercontent.com/zcreativelabs/react-simple-maps/master/topojson-maps/world-110m.json";

    return( <div>
      <ComposableMap>
        <Geographies geography={geoUrl}>
          {({ geographies }) =>
            geographies.map(geo => <Geography key={geo.rsmKey} geography={geo} />)
          }
        </Geographies>
      </ComposableMap>
    </div>)
  }
}

export default Map;
