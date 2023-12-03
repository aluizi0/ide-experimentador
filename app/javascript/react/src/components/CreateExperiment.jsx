import React, { useEffect, useState } from "react";

const CreateExperiment = () => {
	const [nameExperiment, setNameExperiment] = useState(localStorage.getItem("nameExperiment") || "");
	const [factors, setFactors] = useState(JSON.parse(localStorage.getItem("factors")) || {});
	const [trials, setTrials] = useState(JSON.parse(localStorage.getItem("trials")) || {});

	addFactor = (name, value) => {
		// if name and value are not empty and name is not already a factor
		if (name.length > 0 && value.length > 0 && !Object.keys(factors).includes(name)) {
			setFactors({ ...factors, [name]: value });
		}
	};

	removeFactor = (name) => {
		const newFactors = { ...factors };

		// remove factor from trials
		const newTrials = { ...trials };
		Object.keys(trials).forEach((trial) => {
			if (newTrials[trial].includes(name)) {
				newTrials[trial].splice(newTrials[trial].indexOf(name), 1);
			}
		});

		delete newFactors[name];

		setFactors(newFactors);
		setTrials(newTrials);
	};

	addTrial = (name) => {
		if (name.length > 0 && !Object.keys(trials).includes(name)) {
			setTrials({ ...trials, [name]: [] });
		}
	};

	removeTrial = (name) => {
		const newTrials = { ...trials };
		delete newTrials[name];
		setTrials(newTrials);
	};

	addFactorToTrial = (trialName, factorName) => {
		const newTrials = { ...trials };
		// add if not already in trial and factor exists
		if (!newTrials[trialName]?.includes(factorName) && Object.keys(factors).includes(factorName)) {
			newTrials[trialName].push(factorName);
		}
		setTrials(newTrials);
	};

	removeFactorFromTrial = (trialName, factorName) => {
		const newTrials = { ...trials };
		if (newTrials[trialName]?.includes(factorName)) {
			newTrials[trialName].splice(newTrials[trialName].indexOf(factorName), 1);
		}
		setTrials(newTrials);
	};

	submitExperiment = () => {
		const data = { nameExperiment, factors, trials };

		// post /experiments
		fetch("/experiment/create", {
			method: "POST",
			headers: {
				"Content-Type": "application/json",
			},
			body: JSON.stringify(data),
			credentials: "same-origin",
		})
			.then(async (res) => {
				const parse = await res.text();
				console.log(parse);
				return parse;
			})
			.then((res) => {
				console.log(res);
				// clearExperiment();
			});
	};

	clearExperiment = () => {
		setNameExperiment("");
		setFactors({});
		setTrials({});
	};

	// Cache values in local storage so they are not lost on page refresh
	useEffect(() => {
		localStorage.setItem("nameExperiment", nameExperiment);
		localStorage.setItem("factors", JSON.stringify(factors));
		localStorage.setItem("trials", JSON.stringify(trials));
	}, [nameExperiment, factors, trials]);

	return (
		<div className="outer-container">
			<div className="container">
				<h1>Criar Experimento</h1>
				<form>
					<div>
						<input
							placeholder="Nome do experimento"
							type="text"
							className="input-arredondado"
							value={nameExperiment}
							onChange={(e) => setNameExperiment(e.target.value)}
						/>
					</div>
					<h3>Adicionar fator</h3>
					<div>
						<input
							type="text"
							className="input-arredondado"
							id="factorName"
							placeholder="Nome do fator"
						/>
						<input
							type="text"
							className="input-arredondado"
							id="factorValue"
							placeholder="Valor do fator"
						/>
						<button
							type="button"
							className="botao-responsivo"
							onClick={() =>
								addFactor(
									document.getElementById("factorName").value,
									document.getElementById("factorValue").value
								)
							}
						>
							Adicionar
						</button>
					</div>
					<h3>Adicionar teste</h3>
					<div>
						<input
							type="text"
							className="input-arredondado"
							id="trialName"
							placeholder="Nome do teste"
						/>
						<button
							className="botao-responsivo"
							type="button"
							onClick={() => addTrial(document.getElementById("trialName").value)}
						>
							Adicionar
						</button>
					</div>
					<button className="botao-responsivo" type="button" onClick={submitExperiment}>
						Criar experimento
					</button>
					<button className="botao-responsivo-secundario" type="button" onClick={clearExperiment}>
						Limpar
					</button>
				</form>
			</div>
			<div className="list-container">
				<h2>Fatores</h2>
				<ul>
					{Object.keys(factors).map((factor) => (
						<li key={factor}>
							{factor}: {factors[factor]}{" "}
							<button
								type="button"
								className="botao-responsivo-secundario"
								onClick={() => removeFactor(factor)}
							>
								Remover
							</button>
						</li>
					))}
				</ul>
			</div>
			<div className="trial-container">
				<h2>Testes</h2>
				{Object.keys(trials).map((trial) => (
					<div key={trial} className="trail">
						<div className="trail-row">
							{trial}
							<div>
								<div className="dropdown">
									<div role="button" className="botao-responsivo">
										Adicionar fator
									</div>
									<div className="dropdown-content">
										{Object.keys(factors).map((factor) => (
											<span
												key={factor}
												role="button"
												onClick={() => addFactorToTrial(trial, factor)}
											>
												{factor}
											</span>
										))}
									</div>
								</div>
								<button
									className="botao-responsivo-secundario"
									type="button"
									onClick={() => removeTrial(trial)}
								>
									Remover
								</button>
							</div>
						</div>
						{trials[trial].map((factor) => (
							<div key={factor} className="factor-trail">
								{factor}
								<button
									className="botao-responsivo-secundario"
									type="button"
									onClick={() => removeFactorFromTrial(trial, factor)}
								>
									Remover
								</button>
							</div>
						))}
					</div>
				))}
			</div>
		</div>
	);
};

export default CreateExperiment;
