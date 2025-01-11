require 'rails_helper'

RSpec.describe "Urls", type: :request do
  describe "GET /new" do
    it "returns http success" do
      get "/urls/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/urls/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/urls/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /redirect" do
    it "returns http success" do
      get "/urls/redirect"
      expect(response).to have_http_status(:success)
    end
  end

end
