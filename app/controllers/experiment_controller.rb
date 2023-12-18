# Purpose: Handle requests for experiments
class ExperimentController < ApplicationController
  skip_forgery_protection

  # POST create experiment
  # Params:
  #   experimentName: string
  #   factors: { factorName: [factorValue1, factorValue2, ...], ... }
  # Returns:
  #   message: string
  #   experiment: { id: integer, name: string, disabled: boolean, created_at: datetime, updated_at: datetime }
  #   trials: [
  #     {
  #       trial: { id: integer, name: string, disabled: boolean, deleted: boolean, runs: integer, experiment_id: integer, created_at: datetime, updated_at: datetime },
  #       factors: [
  #         { id: integer, name: string, value: string, created_at: datetime, updated_at: datetime },
  #         ...
  #       ]
  #     },
  #     ...
  #   ]
  #   error: string
  #   status: integer
  def create
    experiment_name = params['experimentName']
    factors = params['factors']
    return render_unprocessable_entity("Invalid params") unless create_params_are_valid(experiment_name, factors)

    experiment = save_experiment(experiment_name, factors)

    render_experiment_and_trials(experiment.id)
    rescue StandardError => error
      render_unprocessable_entity(error.message)
  end


  # GET all experiments
  # Returns:
  #   experiments: [
  #     {
  #       experiment: { id: integer, name: string, disabled: boolean, created_at: datetime, updated_at: datetime },
  #       tags: [
  #         { id: integer, name: string, color: string, created_at: datetime, updated_at: datetime },
  #         ...
  #       ]
  #     },
  #     ...
  #   ]
  def get_all
    experiments_with_tags = Experiment.includes(:experiment_tag => :tag)

    experiments = experiments_with_tags.map do |experiment|
      experiment_tags = experiment.experiment_tag.map(&:tag)
      { experiment: experiment, tags: experiment_tags }
    end

    render json: { experiments: experiments }, status: :ok
  end

  # POST add tag to experiment
  # Params:
  #   experiment_id: integer
  #   tag_id: integer
  # Returns:
  #   message: string
  #   experiment_tag: { id: integer, experiment_id: integer, tag_id: integer, created_at: datetime, updated_at: datetime }
  #   error: string
  #   status: integer
  def add_tag
    exp_id = params['experiment_id']
    tag_id = params['tag_id']

    return render_not_found('Experiment not found') if Experiment.where(id: exp_id).empty?

    return render_not_found('Tag not found') if Tag.where(id: tag_id).empty?

    return render_unprocessable_entity('Experiment already has tag') \
      if ExperimentTag.where(experiment_id: exp_id, tag_id: tag_id).any?


    # Add tag to experiment
    experiment_tag = ExperimentTag.create(experiment_id: exp_id, tag_id: tag_id)
    render json: { message: 'success', experiment_tag: experiment_tag }, status: :ok

    rescue StandardError => error
      return render_unprocessable_entity(error.message)
  end

  # DELETE remove tag from experiment
  # Params:
  #   experiment_id: integer
  #   tag_id: integer
  # Returns:
  #   message: string
  #   error: string
  #   status: integer
  def remove_tag
    exp_id = params['experiment_id']
    tag_id = params['tag_id']

    return render_not_found('Experiment not found') if Experiment.where(id: exp_id).empty?

    return render_not_found('Tag not found') if Tag.where(id: tag_id).empty?

    experiment_tag = ExperimentTag.where(experiment_id: exp_id, tag_id: tag_id).first

    return render_unprocessable_entity('Experiment does not have tag') unless experiment_tag&.present?


    experiment_tag.destroy
    render json: { message: 'success' }, status: :ok

    rescue StandardError => error
      render_unprocessable_entity(error.message)
  end

  private

  # Check if params are valid
  # Params:
  #   experiment_name: string
  #   factors: { factorName: [factorValue1, factorValue2, ...], ... }
  # Returns:
  #   boolean
  def create_params_are_valid(experiment_name, factors)
     factors&.is_a?(ActionController::Parameters) \
      && factors.values.all? { |value| value.is_a?(Array) && value.length >= 1 } \
      && factors.keys.all? { |key| key.is_a?(String) } \
      && experiment_name.is_a?(String) \
      && experiment_name.length >= 1
  end

  def render_not_found(message)
    render json: { error: message }, status: :not_found
  end

  def render_unprocessable_entity(message)
    render json: { error: message }, status: :unprocessable_entity
  end

  # Save experiment and its factors and combinations
  # Params:
  #   experiment_name: string
  #   factors: { factorName: [factorValue1, factorValue2, ...], ... }
  # Returns:
  #   experiment: { id: integer, name: string, disabled: boolean, created_at: datetime, updated_at: datetime }
  def save_experiment(experiment_name, factors)
    experiment = Experiment.create(name: experiment_name, disabled: false)
    save_factors(factors)
    values = factors.values
    save_combinations(experiment.id, factors.keys, values[0].product(*values[1..-1]))
    return experiment
  end

  # Save factors
  # Params:
  #   factors: { factorName: [factorValue1, factorValue2, ...], ... }
  # Returns:
  #   void
  def save_factors(factors)
    # Save factors (should not save if factor with same name and value already exists)
    factors.each do |factor_name, factor_values|
      save_factor(factor_name, factor_values)
    end
  end

  def save_factor(factor_name, factor_values)
    factor_values.each do |value|
      if Factor.where(name: factor_name, value: value).empty?
        Factor.create(name: factor_name, value: value)
      end
    end
  end

  # Save combinations
  # Generate all possible combinations of factors and save them
  # as [{factor1: value1, factor2: value1}, {factor1: value1, factor2: value2}, ...]
  # Params:
  #   experiment_id: integer
  #   factors: [factorName1, factorName2, ...]
  #   values: [[factorValue1, factorValue2, ...], [factorValue1, factorValue2, ...], ...]
  # Returns:
  #   void
  def save_combinations(experiment_id, keys, combinations)
    # combinations_keys looks like:
    # [ [ [factor1: value1, factor2: value1], [factor1: value1, factor2: value2], ... ],
    combinations_keys = combinations.map do |combination|
      keys.zip(combination).map { |key, value| { key => value } }
    end

    combinations_keys.each do |combination|
      save_trial(experiment_id, combination)
    end
  end

  def save_trial(experiment_id, combination)
    # Name is the combination of values e.g. value1-value2-value3
    name = combination.map { |factor| factor.values[0] }.join('-')
    trial = Trial.create(name: name, disabled: false, deleted: false, runs: 0, experiment_id: experiment_id)

    combination.each do |value|
      factor = Factor.where(name: value.keys[0], value: value.values[0]).first
      TrialFactor.create(factor_id: factor.id, trial_id: trial.id)
    end
  end


  def render_experiment_and_trials(experiment_id)
    experiment = Experiment.find(experiment_id)
    trials = get_trials(experiment_id)
    render json: {
      message: 'success',
      experiment: experiment,
      trials: trials
    }, status: :ok
  end

  def get_trials(experiment_id)
    Trial.where(experiment_id: experiment_id).map do |trial|
      factors = get_factors(trial.id)
      { trial: trial, factors: factors }
    end
  end

  def get_factors(trial_id)
    trial_factors = TrialFactor.where(trial_id: trial_id)
    trial_factors.map { |trial_factor| Factor.find(trial_factor.factor_id) }
  end

end
