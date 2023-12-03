class ExperimentController < ApplicationController
  skip_forgery_protection
  def index
    render
  end

  def create 
    # Check if params are valid
    if params['experimentName'].nil? || params['factors'].nil?
      render json: { error: 'Invalid params' }, status: :unprocessable_entity
      return
    end

    # Check if factors is a hash with arrays as values
    if params['factors'].class != ActionController::Parameters || params['factors'].values.any? { |value| value.class != Array }
      puts params['factors'].class
      render json: { error: 'Invalid params' }, status: :unprocessable_entity
      return
    end

    # Save experiment
    experiment = Experiment.create(name: params['experimentName'], disabled: false)

    # Save factors (should not save if factor with same name and value already exists)
    params['factors'].each do |factor|
      factor[1].each do |value|
        if Factor.where(name: factor[0], value: value).empty?
          Factor.create(name: factor[0], value: value)
        end
      end
    end

    # Generate all possible combinations of factors and save them
    # as [{factor1: value1, factor2: value1}, {factor1: value1, factor2: value2}, ...]

    # Get all factors from the request
    factors = params['factors'].keys

    # Get all values from the request
    values = params['factors'].values

    # Get all possible combinations of values
    combinations = values[0].product(*values[1..-1])

    # Save all combinations
    combinations.each do |combination|
      # Create trial
      trial = Trial.create(name: combination.join('-'), disabled: false, deleted: false, runs: 0, experiment_id: experiment.id)

      # Create trial factors
      combination.each do |value|
        factor = Factor.where(name: factors[combination.index(value)], value: value).first
        TrialFactor.create(factor_id: factor.id, trial_id: trial.id)
      end
    end

    render json: { message: 'success', experiment: experiment }, status: :ok

    rescue StandardError => e
      render json: { error: e.message }, status: :unprocessable_entity
  end


  # GET all experiments
  def get_all
    experiments = Experiment.all
    render json: { experiments: experiments }, status: :ok
  end

end
