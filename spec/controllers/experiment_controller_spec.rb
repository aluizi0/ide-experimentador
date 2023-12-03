require 'rails_helper'

RSpec.describe ExperimentController, type: :controller do
  context 'POST #create' do
    it 'should create an experiment' do
      post :create, params: { nameExperiment: 'test', factors: { 'velocidade' => '15' }, trials: { 'test' => ['velocidade'] } }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['message']).to eq('success')
    end

    it 'should not create an experiment with a trial with invalid factor' do
      post :create, params: { nameExperiment: 'test', factors: { 'velocidade' => '10' }, trials: { 'test' => ['velocidade2'] } }
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'should not create an experiment without trials' do
      post :create, params: { nameExperiment: 'test', factors: { 'test' => 'test' } }
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'should not create an experiment without factors and trials' do
      post :create, params: { nameExperiment: 'test' } 
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'should not create an experiment without name' do
      post :create, params: { factors: { 'test' => 'test' }, trials: { 'test' => ['test'] } }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
