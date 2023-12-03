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
end
