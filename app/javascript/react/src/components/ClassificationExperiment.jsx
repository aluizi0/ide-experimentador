import React, { useEffect, useState } from "react";
import toast from "react-simple-toasts";
import 'react-simple-toasts/dist/theme/success.css';
import 'react-simple-toasts/dist/theme/failure.css';

const ClassificationExperiment = (props) => {
  const [experimentList, setExperimentList] = useState([]);
  const [filteredExperiments, setFilteredExperiments] = useState([]); 
  const [searchText, setSearchText] = useState("");
  const [tags, setTags] = useState([])

  const fetchExperiments = async () => {
    try {
      const response = await fetch("/experiment/get_all");
      const data = (await response.json()).experiments;
      setExperimentList(data)
      setFilteredExperiments(data)
    } catch (error) {
      console.error("Error fetching experiments:", error);
    }
  };

  useEffect(() => {
    fetchExperiments();

    fetch("/tags/get_all")
    .then((response) => response.json())
    .then((data) => {
        setTags(data)
        return data
    }).catch((error) => {
        console.error("Error fetching tags:", error)
    })
  }, []);

  const handleChange = (e) => {
    setSearchText(e.target.value)
    setFilteredExperiments(experimentList.filter((experiment) =>
      experiment.name.toLowerCase().includes(searchText.toLowerCase()))
    )
  }

  const addTag = (experimentId, tagId) => {
    const data = { experiment_id: experimentId, tag_id: parseInt(tagId) }

    fetch("/experiment/add_tag", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(data),
    }).then((response) => {
      fetchExperiments();
      toast("Tag adicionada com sucesso!", { theme: "success", position: "top-right" });
    }).catch((error) => {
      console.error("Error adding tag:", error)
      toast("Erro ao adicionar tag!", { theme: "failure", position: "top-right" });
    })
  }

  const removeTag = (experimentId, tagId) => {
    const data = { experiment_id: experimentId, tag_id: parseInt(tagId) }

    fetch("/experiment/remove_tag", {
      method: "DELETE",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(data),
    }).then((response) => {
      fetchExperiments();
      toast("Tag removida com sucesso!", { theme: "success", position: "top-right" });
    }).catch((error) => {
      console.error("Error removing tag:", error)
      toast("Erro ao remover tag!", { theme: "failure", position: "top-right" });
    })
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
        {filteredExperiments.map(({experiment, tags: tags_}) => (
          <li key={experiment.id}>
            {experiment.name}
            <select onChange={(e) => addTag(experiment.id, e.target.value)} id={`select-${experiment.id}`}>
              {tags.map((tag) => (
                <option value={tag.id} key={tag.id} id={`tag-${tag.id}`}>
                  {tag.name}
                </option>
              ))}
            </select>

            <ul>
              {tags_.map((tag) => (
                <li key={tag.id}>
                  {tag.name}
                  <button onClick={() => removeTag(experiment.id, tag.id)}>X</button>
                </li>
              ))}
            </ul>
          </li>
        ))}
      </ul>
    </div>
  );
};

export default ClassificationExperiment;
