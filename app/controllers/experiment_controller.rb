class ExperimentController < ApplicationController
  skip_forgery_protection
  def index
    render
  end

  def create
    # Check if params are valid
    if params['nameExperiment'].nil? || params['factors'].nil? || params['trials'].nil?
      render json: { error: 'Invalid params' }, status: :unprocessable_entity
      return
    end

    # Check if factors are valid
    factors_ = params['factors']
    factors_.each do |name, value|
      if name.nil? || value.nil?
        render json: { error: 'Invalid factors' }, status: :unprocessable_entity
        return
      end
    end

    # Check if trials are valid
    trials = params['trials']
    trials.each do |name, factors|
      if name.nil? || factors.nil?
        render json: { error: 'Invalid trials' }, status: :unprocessable_entity
        return
      end
      factors.each do |factor|
        if factors_[factor].nil?
          render json: { error: 'Invalid trials' }, status: :unprocessable_entity
          return
        end
      end
    end

    # Save factors
    factors = params['factors']
    saved_factors = {}
    factors.each do |name, value|
      saved_factors[name] = Factor.create(name: name, value: value)
    end

    # Save experiment
    experiment = Experiment.create(name: params['nameExperiment'], disabled: false)

    # Save trials
    trials = params['trials']
    trials.each do |name, factors|
      trial = Trial.create(name: name, experiment_id: experiment.id, disabled: false, deleted: false, runs: 0)
      factors.each do |factor|
        TrialFactor.create(trial_id: trial.id, factor_id: saved_factors[factor].id)
      end
    end

    render json: { message: 'success', experiment: experiment }, status: :ok

    rescue StandardError => e
      render json: { error: e.message }, status: :unprocessable_entity
  end
end
