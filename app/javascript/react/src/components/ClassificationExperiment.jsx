import React, { useEffect, useState } from "react";
import AddTag from "./AddTag";

const ClassificationExperiment = (props) => {
  const [experimentList, setExperimentList] = useState([]);
  const [filteredExperiments, setFilteredExperiments] = useState([]); 
  const [searchText, setSearchText] = useState("");

  useEffect(() => {
    // Fetch experiments from the API
    const fetchExperiments = async () => {
      const response = await fetch("/experiment/get_all");
      const data = await response.json();

      if (response.ok) {
        setExperimentList(data.experiments);
        return data.experiments
      } else {
        console.error("Error fetching experiments:", data.error);
      }
    };

    const result = fetchExperiments();
    result.then((result) => {
      for (let index = 0; index < result.length; index++) {
        result[index]["show"] = false;
      }
      setExperimentList(result)
      setFilteredExperiments(result)
    });
    
  }, []);

  const toggleHide = (idx) => {
    const tmp = []
    for (let index = 0; index < filteredExperiments.length; index++) {
      tmp.push(filteredExperiments[index])
      if (idx == index) {
        tmp[index]["show"] = true
      }

    }
    setFilteredExperiments(tmp)
    console.log(filteredExperiments)
  }

  const handleChange = (e) => {
    setSearchText(e.target.value)
    setFilteredExperiments(experimentList.filter((experiment) =>
      experiment.name.toLowerCase().includes(searchText.toLowerCase()))
    )
  }

  return (
    <div>
      <h2>Classificação de Experimentos</h2>
      <input
        type="text"
        placeholder="Pesquisar experimento..."
        value={searchText}
        onChange={(e) => handleChange(e)}
      />
      <ul>
        {filteredExperiments.map((experiment, idx) => (
          <li key={experiment.id}>
            {experiment.name}
            <button onClick={() => toggleHide(idx)} >Adicionar tag</button>
            {experiment.show && <AddTag/>}
          </li>
        ))}
      </ul>
    </div>
  );
};

export default ClassificationExperiment;
