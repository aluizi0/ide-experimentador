import React, { useEffect, useState } from "react";

const ClassificationExperiment = (props) => {
  const [experimentList, setExperimentList] = useState([]);
  const [searchText, setSearchText] = useState("");

  useEffect(() => {
    // Fetch experiments from the API
    const fetchExperiments = async () => {
      const response = await fetch("/experiment/get_all");
      const data = await response.json();

      if (response.ok) {
        setExperimentList(data.experiments);
      } else {
        console.error("Error fetching experiments:", data.error);
      }
    };

    fetchExperiments();
  }, []);

  const filteredExperiments = experimentList.filter((experiment) =>
    experiment.name.toLowerCase().includes(searchText.toLowerCase())
  );

  return (
    <div>
      <h2>Classificação de Experimentos</h2>
      <input
        type="text"
        placeholder="Pesquisar experimento..."
        value={searchText}
        onChange={(e) => setSearchText(e.target.value)}
      />
      <ul>
        {filteredExperiments.map((experiment) => (
          <li key={experiment.id}>{experiment.name}</li>
        ))}
      </ul>
    </div>
  );
};

export default ClassificationExperiment;
