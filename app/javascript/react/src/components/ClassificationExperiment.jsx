import React, { useEffect, useState } from "react";
import toast from "react-simple-toasts";

const ClassificationExperiment = () => {
	const [experimentList, setExperimentList] = useState([]);
	const [filteredExperiments, setFilteredExperiments] = useState([]);
	const [tags, setTags] = useState([]);
	const [searchText, setSearchText] = useState("");
	const [selectedTagId, setSelectedTagId] = useState(null);

	const fetchExperiments = async () => {
		try {
			const response = await fetch("/experiment/get_all");
			const data = (await response.json()).experiments;
			setExperimentList(data);
			setFilteredExperiments(
				data.filter(({ experiment }) => experiment.name?.toLowerCase().includes(searchText))
			);
		} catch (error) {
			console.error("Error fetching experiments:", error);
		}
	};

	useEffect(() => {
		fetchExperiments();

		fetch("/tags/get_all")
			.then((response) => response.json())
			.then((data) => {
				setTags(data);
				return data;
			})
			.catch((error) => {
				console.error("Error fetching tags:", error);
			});
	}, []);

	const handleChange = (e) => {
		const searchText = e.target.value.toLowerCase();
		setSearchText(searchText);
		setFilteredExperiments(
			experimentList.filter(({ experiment }) => experiment.name?.toLowerCase().includes(searchText))
		);
	};

	const handleSelectedTagId = (tagId) => {
		if (selectedTagId === tagId) {
			setSelectedTagId(null);
		} else {
			setSelectedTagId(tagId);
		}
	};

	const addTag = async (experimentId, tagId) => {
		try {
			const data = { experiment_id: experimentId, tag_id: parseInt(tagId) };
			const response = await fetch("/experiment/add_tag", {
				method: "POST",
				headers: {
					"Content-Type": "application/json",
				},
				body: JSON.stringify(data),
			}).then(async (res) => {
				const parse = JSON.parse(await res.text());
				return parse;
			});

			if (response?.error) {
				toast("Erro ao adicionar tag!", { theme: "failure", position: "top-right" });
				return;
			}

			fetchExperiments();

			toast("Tag adicionada com sucesso!", { theme: "success", position: "top-right" });
		} catch (error) {
			console.error("Error adding tag:", error);
			toast("Erro ao adicionar tag!", { theme: "failure", position: "top-right" });
		}
	};

	const removeTag = async (experimentId, tagId) => {
		try {
			const data = { experiment_id: experimentId, tag_id: parseInt(tagId) };
			const response = await fetch("/experiment/remove_tag", {
				method: "DELETE",
				headers: {
					"Content-Type": "application/json",
				},
				body: JSON.stringify(data),
			}).then(async (res) => {
				const parse = JSON.parse(await res.text());
				return parse;
			});

			if (response?.error) {
				toast("Erro ao remover tag!", { theme: "failure", position: "top-right" });
				return;
			}

			fetchExperiments();

			toast("Tag removida com sucesso!", { theme: "success", position: "top-right" });
		} catch (error) {
			console.error("Error removing tag:", error);
			toast("Erro ao remover tag!", { theme: "failure", position: "top-right" });
		}
	};

	return (
		<div className="classification-experiment">
			<h1>Classificação de Experimentos</h1>
			<input
				type="text"
				placeholder="Pesquisar experimento..."
				value={searchText}
				onChange={(e) => handleChange(e)}
			/>
			<div className="class-exp-tags">
				<h2>Tags</h2>
				<ul>
					{tags.map((tag) => (
						<li
							id={`tag-${tag.id}`}
							key={tag.id}
							onClick={() => handleSelectedTagId(tag.id)}
							style={{
								backgroundColor: tag.color,
								opacity: selectedTagId === tag.id ? 1 : 0.5,
							}}
						>
							{tag.name}
						</li>
					))}
				</ul>
			</div>
			<h2>Experimentos</h2>
			<ul>
				{filteredExperiments.map(({ experiment, tags: tags_ }) => (
					<li key={experiment.id} id={`experiment-${experiment.id}-tags`}>
						<div className="experiment-tags-header">
							<p>{experiment.name}</p>
							<button
								id={`add-tag-${experiment.id}`}
								onClick={() => addTag(experiment.id, selectedTagId)}
							>
								+
							</button>
						</div>
						<ul className="experiment-tags">
							{tags_.map((tag) => (
								<li key={tag.id}>
									<span style={{ backgroundColor: tag.color }}>{tag.name}</span>
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
