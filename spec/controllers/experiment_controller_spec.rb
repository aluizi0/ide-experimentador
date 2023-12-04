require 'rails_helper'

RSpec.describe ExperimentController, type: :controller do
  context 'POST #create' do
    it 'should create an experiment' do
      post :create, params: { experimentName: 'test', factors: { 'velocidade' => ['1', '2'], 'temperatura' => ['4', '5'] } }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['message']).to eq('success')
    end

    it 'should not create an experiment if experimentName is nil' do
      post :create, params: {factors: { 'velocidade' => ['1', '2'], 'temperatura' => ['4', '5'] } }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)['error']).to eq('Invalid params')
    end

    it 'should not create an experiment if factors is nil' do
      post :create, params: { experimentName: 'test' }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)['error']).to eq('Invalid params')
    end

    it 'should not create an experiment if factors is not a hash' do
      post :create, params: { experimentName: 'test', factors: 'velocidade' }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)['error']).to eq('Invalid params')
    end

    it 'should not create an experiment if factors is a hash with values that are not arrays' do
      post :create, params: { experimentName: 'test', factors: { 'velocidade' => '1', 'temperatura' => ['4', '5'] } }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)['error']).to eq('Invalid params')
    end
  end

  context 'POST #add_tag' do
    # setup
    before(:each) do
      Experiment.create(id: 1, name: 'test')
      Tag.create(id: 1, name: 'tag')
    end

    it 'should add tag to experiment' do
      post :add_tag, params: { experiment_id: 1, tag_id: 1 }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['message']).to eq('success')
    end

    it 'should not add tag to experiment if experiment_id is nil' do
      post :add_tag, params: { tag_id: 1 }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)['error']).to eq('Invalid params')
    end

    it 'should not add tag to experiment if tag_id is nil' do
      post :add_tag, params: { experiment_id: 1 }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)['error']).to eq('Invalid params')
    end

    it 'should not add tag to experiment if experiment does not exist' do
      post :add_tag, params: { experiment_id: 2, tag_id: 1 }

      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)['error']).to eq('Experiment not found')
    end

    it 'should not add tag to experiment if tag does not exist' do
      post :add_tag, params: { experiment_id: 1, tag_id: 2 }

      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)['error']).to eq('Tag not found')
    end

    it 'should not add tag to experiment if experiment already has tag' do
      ExperimentTag.create(experiment_id: 1, tag_id: 1)
      post :add_tag, params: { experiment_id: 1, tag_id: 1 }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)['error']).to eq('Experiment already has tag')
    end

  end
end
