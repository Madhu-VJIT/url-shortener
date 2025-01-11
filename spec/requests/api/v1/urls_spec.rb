require 'swagger_helper'

RSpec.describe 'Api::V1::Urls', type: :request do
  path '/api/v1/urls' do
    get 'Lists all URLs' do
      tags 'URLs'
      produces 'application/json'
      security [Bearer: []]
      
      response '200', 'URLs found' do
        let(:Authorization) { "Bearer #{ENV['API_TOKEN']}" }
        
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data).to have_key('urls')
        end
      end

      response '401', 'unauthorized' do
        let(:Authorization) { 'Bearer invalid_token' }
        run_test!
      end
    end

    post 'Creates a shortened URL' do
      tags 'URLs'
      consumes 'application/json'
      produces 'application/json'
      security [Bearer: []]
      
      parameter name: :url, in: :body, schema: {
        type: :object,
        properties: {
          url: {
            type: :object,
            properties: {
              long_url: { type: :string, example: 'https://example.com' }
            },
            required: ['long_url']
          }
        }
      }

      response '201', 'URL created' do
        let(:Authorization) { "Bearer #{ENV['API_TOKEN']}" }
        let(:url) { { url: { long_url: 'https://example.com' } } }
        
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data).to have_key('short_url')
          expect(data).to have_key('long_url')
        end
      end

      response '401', 'unauthorized' do
        let(:Authorization) { 'Bearer invalid_token' }
        let(:url) { { url: { long_url: 'https://example.com' } } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:Authorization) { "Bearer #{ENV['API_TOKEN']}" }
        let(:url) { { url: { long_url: 'invalid-url' } } }
        run_test!
      end
    end
  end

  path '/api/v1/urls/{id}' do
    delete 'Deletes a URL' do
      tags 'URLs'
      produces 'application/json'
      security [Bearer: []]
      
      parameter name: :id, in: :path, type: :integer

      response '204', 'URL deleted' do
        let(:Authorization) { "Bearer #{ENV['API_TOKEN']}" }
        let(:id) { create(:url).id }
        run_test!
      end

      response '401', 'unauthorized' do
        let(:Authorization) { 'Bearer invalid_token' }
        let(:id) { 1 }
        run_test!
      end

      response '404', 'URL not found' do
        let(:Authorization) { "Bearer #{ENV['API_TOKEN']}" }
        let(:id) { 999999 }
        run_test!
      end
    end
  end
end