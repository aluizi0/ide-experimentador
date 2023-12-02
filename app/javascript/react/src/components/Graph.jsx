import React, {useEffect, useState} from 'react'
                                                        
const Graph = (props) => {                                   
  
  let [count, setCount] = useState(0)
  useEffect(() => {
    fetch("/hello/worldGet").then(async res=>{
      const parse = await res.text()
      console.log(parse)
      return parse
    }).then(res=>setReq(res))
  }, [])
  return (
    <div>
      <h1>Counter prop:{props.trialID}: {count}</h1>
      <button onClick={()=>{
        setCount(count+1)
      }}> Add </button>
    </div>
  )                   
}                                                       
                                        
export default Graph
