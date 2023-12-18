import React, { useEffect, useState } from "react";
import toast from "react-simple-toasts";
import { useClickAway } from "@uidotdev/usehooks";

const CreateExperiment = () => {
	const [experimentName, setExperimentName] = useState(
		localStorage.getItem("experimentName") || ""
	);
	const [factors, setFactors] = useState(JSON.parse(localStorage.getItem("factors")) || {});
	const [value, setValue] = useState("");
	const [open, setOpen] = useState(null);

	const handleOpen = ({ experiment, trials }) => {
		setOpen({ experiment, trials });
	};
	const handleClose = () => {
		setOpen(null);
	};
	const ref = useClickAway(handleClose);

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
				return parse;
			})
			.then((res) => {
				if (res?.error) {
					toast("Erro ao criar o experimento!", {
						position: "top-right",
						theme: "failure",
					});
					return;
				}
				handleOpen(res);
				toast("Experimento criado com sucesso!", { position: "top-right", theme: "success" });
				clearExperiment();
			})
			.catch((err) => {
				toast("Erro ao criar o experimento!", {
					position: "top-right",
					theme: "failure",
				});
			});
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
		<>
			{/* Modal de experimento criado */}
			<div id="experimentModal" className="modal" style={{ display: open ? "block" : "none" }}>
				<div className="modal-content" ref={ref}>
					<div className="modal-header">
						<h2>Experimento criado</h2>
						<button className="close" id="closeModal" onClick={handleClose}>
							&times;
						</button>
					</div>
					<div className="modal-body">
						<div className="experiment-info">
							<p>{open?.experiment?.name}</p>
							<span>{open?.experiment?.id}</span>
						</div>
						<h3>Ensaios</h3>
						{open?.trials?.map((trial) => (
							<div key={trial.trial.id} className="exp-info-trial">
								<div className="experiment-info">
									<h4>Ensaio {trial.trial.name}</h4>
									<span>{trial.trial.id}</span>
								</div>
								<h5>Fatores</h5>
								<table>
									<tbody>
										{trial.factors.map((factor) => (
											<tr key={factor.id}>
												<td>{factor.name}</td>
												<td>{factor.value}</td>
											</tr>
										))}
									</tbody>
								</table>
							</div>
						))}
					</div>
				</div>
			</div>
			{/* Fim do modal de experimento criado */}

			{/* Formulário de criação de experimento */}
			<div className="outer-container">
				<div className="form-container">
					<h1>Criar Experimento</h1>
					<form>
						<input
							id="experimentName"
							placeholder="Nome do experimento"
							type="text"
							value={experimentName}
							onChange={(e) => setExperimentName(e.target.value)}
						/>
						<hr></hr>
						<h3>Adicionar fator</h3>
						<input type="text" id="factorName" placeholder="Nome do fator" />
						<button
							id="addFactor"
							type="button"
							onClick={() => addFactor(document.getElementById("factorName").value)}
						>
							Adicionar
						</button>
						<p>Valor para fator</p>
						<input
							type="text"
							id="factorValue"
							placeholder="Valor do fator"
							value={value}
							onChange={(e) => setValue(e.target.value)}
						/>
						<span className="info">
							Para adicionar o valor inserido ao fator, clique no botão 'Adicionar valor' ao lado do
							nome do fator na seção 'Fatores'.
						</span>
						<button type="button" id="createExperiment" onClick={submitExperiment}>
							Criar experimento
						</button>
						<button type="button" onClick={clearExperiment}>
							Limpar
						</button>
					</form>
				</div>
				<div className="trial-container">
					<h1>Fatores</h1>
					{Object.keys(factors).map((factor) => (
						<div key={factor} className="trial">
							<div className="trial-header">
								{factor}
								<div>
									<button id={`add-to-${factor}`} onClick={() => addValueToFactor(factor, value)}>Adicionar valor</button>
									<button onClick={() => removeFactor(factor)}>&times;</button>
								</div>
							</div>
							{factors[factor].map((value) => (
								<div key={value} className="factor-trial">
									{value}
									<button type="button" onClick={() => removeValueFromFactor(factor, value)}>
										&times;
									</button>
								</div>
							))}
						</div>
					))}
				</div>
			</div>
		</>
	);
};

export default CreateExperiment;
