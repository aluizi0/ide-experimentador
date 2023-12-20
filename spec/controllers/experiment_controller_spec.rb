require 'rails_helper'

RSpec.describe ExperimentController, type: :controller do
  context 'POST #create' do
    it 'should create an experiment' do
      post :create, params: { experimentName: 'test', factors: { 'velocidade' => ['1', '2'], 'temperatura' => ['4', '5'] }, robots: ['r2d2'] }


      body = JSON.parse(response.body)
      expect(body['experiment']['name']).to eq('test')
      expect(body['experiment']['disabled']).to eq(false)
      expect(body['trials'].length).to eq(4)

      body['trials'].each do |trial|
        expect(trial['trial']['disabled']).to eq(false)
        expect(trial['trial']['deleted']).to eq(false)
        expect(trial['trial']['runs']).to eq(0)
        expect(trial['trial']['experiment_id']).to eq(body['experiment']['id'])
      end

      trial_names = body['trials'].map { |trial| trial['trial']['name'] }
      expect(trial_names).to include('4-1', '4-2', '5-1', '5-2').or include('1-4', '1-5', '2-4', '2-5')

      expect(body['robots'].length).to eq(1)
      expect(body['robots'][0]['name']).to eq('r2d2')

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['message']).to eq('success')
    end

    it 'should create an experiment with multiple robots' do
      post :create, params: { experimentName: 'test', factors: { 'velocidade' => ['1', '2'], 'temperatura' => ['4', '5'] }, robots: ['r2d2', 'c3po'] }

      robots = JSON.parse(response.body)['robots']

      expect(robots.length).to eq(2)
      expect(robots.map { |robot| robot['name'] }).to include('r2d2', 'c3po')

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['message']).to eq('success')
    end

    it 'should not create an experiment if no robots are given' do
      post :create, params: { experimentName: 'test', factors: { 'velocidade' => ['1', '2'], 'temperatura' => ['4', '5'] } }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)['error']).to eq('Invalid params')
    end

    it 'should not create an experiment if robots name is empty' do
      post :create, params: { experimentName: 'test', factors: { 'velocidade' => ['1', '2'], 'temperatura' => ['4', '5'] }, robots: [''] }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)['error']).to eq('Invalid params')
    end

    it 'should not create an experiment if robots array is empty' do
      post :create, params: { experimentName: 'test', factors: { 'velocidade' => ['1', '2'], 'temperatura' => ['4', '5'] }, robots: [] }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)['error']).to eq('Invalid params')
    end

    it 'should not create an experiment if experimentName is nil' do
      post :create, params: {factors: { 'velocidade' => ['1', '2'], 'temperatura' => ['4', '5'] } }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)['error']).to eq('Invalid params')
    end

    it 'should not create an experiment if experimentName is empty' do
      post :create, params: { experimentName: '', factors: { 'velocidade' => ['1', '2'], 'temperatura' => ['4', '5'] } }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)['error']).to eq('Invalid params')
    end

    it 'should not create an experiment if factors is nil' do
      post :create, params: { experimentName: 'test' }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)['error']).to eq('Invalid params')
    end

    it 'should not create an experiment if factors is empty' do
      post :create, params: { experimentName: 'test', factors: {} }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)['error']).to eq('Invalid params')
    end

    it 'should not create an experiment if factors array is empty' do
      post :create, params: { experimentName: 'test', factors: { 'velocidade' => [], 'temperatura' => [] } }

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
      Tag.create(id: 1, name: 'tag', color: 'red')
    end

    it 'should add tag to experiment' do
      post :add_tag, params: { experiment_id: 1, tag_id: 1 }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['message']).to eq('success')
    end

    it 'should not add tag to experiment if experiment_id is nil' do
      post :add_tag, params: { tag_id: 1 }

      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)['error']).to eq('Experiment not found')
    end

    it 'should not add tag to experiment if tag_id is nil' do
      post :add_tag, params: { experiment_id: 1 }

      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)['error']).to eq('Tag not found')
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

  context 'DELETE #remove_tag' do

    # setup
    before(:each) do
      Experiment.create(id: 1, name: 'test')
      Tag.create(id: 1, name: 'tag', color: 'red')
      ExperimentTag.create(experiment_id: 1, tag_id: 1)
      Experiment.create(id: 2, name: 'test2')
      Tag.create(id: 2, name: 'tag2', color: 'blue')
    end

    it 'should remove tag from experiment' do
      delete :remove_tag, params: { experiment_id: 1, tag_id: 1 }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['message']).to eq('success')

      expect(ExperimentTag.where(experiment_id: 1, tag_id: 1).any?).to eq(false)
    end

    it 'should not remove tag from experiment if experiment_id is nil' do
      delete :remove_tag, params: { tag_id: 1 }

      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)['error']).to eq('Experiment not found')
    end

    it 'should not remove tag from experiment if tag_id is nil' do
      delete :remove_tag, params: { experiment_id: 1 }

      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)['error']).to eq('Tag not found')
    end

    it 'should not remove tag from experiment if experiment does not exist' do
      delete :remove_tag, params: { experiment_id: 3, tag_id: 1 }

      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)['error']).to eq('Experiment not found')
    end

    it 'should not remove tag from experiment if tag does not exist' do
      delete :remove_tag, params: { experiment_id: 1, tag_id: 3 }

      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)['error']).to eq('Tag not found')
    end

    it 'should not remove tag from experiment if experiment does not have tag' do
      delete :remove_tag, params: { experiment_id: 2, tag_id: 2 }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)['error']).to eq('Experiment does not have tag')
    end

    it 'should not remove tag from experiment if experiment has tag but not the one being removed' do
      delete :remove_tag, params: { experiment_id: 1, tag_id: 2 }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)['error']).to eq('Experiment does not have tag')
    end
  end

  context 'GET #get_all' do
    # setup
    before(:each) do
      Experiment.create(id: 1, name: 'test', disabled: false)
      Factor.create(id: 1, name: 'velocidade', value: '1')
      Trial.create(id: 1, name: '1', experiment_id: 1, disabled: false, deleted: false, runs: 0)
      TrialFactor.create(id: 1, trial_id: 1, factor_id: 1)
      Tag.create(id: 1, name: 'tag', color: 'red')
      ExperimentTag.create(id: 1, experiment_id: 1, tag_id: 1)
    end

    it 'should get all experiments' do
      get :get_all

      expect(response).to have_http_status(:ok)
      experiments = JSON.parse(response.body)['experiments']

      expect(experiments.length).to eq(1)
      experiment = experiments[0]['experiment']
      expect(experiment['id']).to eq(1)

      tags = experiments[0]['tags']
      expect(tags.length).to eq(1)
      tag = tags[0]
      expect(tag['id']).to eq(1)
    end
  end
end
