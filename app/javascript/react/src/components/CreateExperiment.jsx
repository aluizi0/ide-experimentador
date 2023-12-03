import React, { useEffect, useState } from "react";
import toast from "react-simple-toasts";
import 'react-simple-toasts/dist/theme/success.css';
import 'react-simple-toasts/dist/theme/failure.css';


const CreateExperiment = () => {
	const [experimentName, setExperimentName] = useState(
		localStorage.getItem("experimentName") || ""
	);
	const [factors, setFactors] = useState(JSON.parse(localStorage.getItem("factors")) || {});
	const [value, setValue] = useState("");

	addFactor = (name) => {
		if (name.length > 0 && !Object.keys(factors).includes(name)) {
			setFactors({ ...factors, [name]: [] });
		}
	};

	removeFactor = (name) => {
		const newFactors = { ...factors };
		delete newFactors[name];
		setFactors(newFactors);
	};

	addValueToFactor = (factorName, value) => {
		const newFactors = { ...factors };
		if (newFactors[factorName] && !newFactors[factorName].includes(value) && value.length > 0) {
			newFactors[factorName].push(value);
		}
		setFactors(newFactors);
	};

	removeValueFromFactor = (factorName, value) => {
		const newFactors = { ...factors };
		if (newFactors[factorName]?.includes(value)) {
			newFactors[factorName] = newFactors[factorName].filter((v) => v !== value);
		}
		setFactors(newFactors);
	};


	submitExperiment = () => {
		const data = { experimentName, factors };

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
				const parse = JSON.parse(await res.text());
				console.log(parse);
				return parse;
			})
			.then((res) => {
				if (res?.error) {
					toast("Erro ao criar o experimento!", {
						position: "top-right", theme: "failure"
					})
					return;
				}
				toast("Experimento criado com sucesso!", { position: "top-right", theme: "success" });
				clearExperiment();
			}).catch((err) => {
				toast("Erro ao criar o experimento!", {
					position: "top-right", theme: "failure"
				})
			})
	};

	clearExperiment = () => {
		setExperimentName("");
		setFactors({});
	};

	// Cache values in local storage so they are not lost on page refresh
	useEffect(() => {
		localStorage.setItem("experimentName", experimentName);
		localStorage.setItem("factors", JSON.stringify(factors));
	}, [experimentName, factors]);

	return (
		<div className="outer-container">
			<div className="container">
				<h1>Criar Experimento</h1>
				<form>
					<div>
						<input
							id="experimentName"
							placeholder="Nome do experimento"
							type="text"
							className="input-arredondado"
							value={experimentName}
							onChange={(e) => setExperimentName(e.target.value)}
						/>
					</div>
					<div>
						<h3>Adicionar fator</h3>
						<input
							type="text"
							className="input-arredondado"
							id="factorName"
							placeholder="Nome do fator"
						/>
						<button
							id="addFactor"
							className="botao-responsivo"
							type="button"
							onClick={() => addFactor(document.getElementById("factorName").value)}
						>
							Adicionar
						</button>
						<p>Valor para fator</p>
						<input
							type="text"
							className="input-arredondado"
							id="factorValue"
							placeholder="Valor do fator"
							value={value}
							onChange={(e) => setValue(e.target.value)}
						/>
					</div>
					<button
						className="botao-responsivo"
						type="button"
						id="createExperiment"
						onClick={submitExperiment}
					>
						Criar experimento
					</button>
					<button className="botao-responsivo-secundario" type="button" onClick={clearExperiment}>
						Limpar
					</button>
				</form>
			</div>
			<div className="trial-container">
				<h2>Fatores</h2>
				{Object.keys(factors).map((factor) => (
					<div key={factor} className="trail">
						<div className="trail-row">
							{factor}
							<div>
								<div
									onClick={() => addValueToFactor(factor, value)}
									role="button"
									className="botao-responsivo"
								>
									Adicionar valor ao fator
								</div>
								<button
									className="botao-responsivo-secundario"
									type="button"
									onClick={() => removeFactor(factor)}
								>
									Remover
								</button>
							</div>
						</div>
						{factors[factor].map((value) => (
							<div key={value} className="factor-trail">
								{value}
								<button
									className="botao-responsivo-secundario"
									type="button"
									onClick={() => removeValueFromFactor(factor, value)}
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
