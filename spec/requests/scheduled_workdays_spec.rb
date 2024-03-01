require 'rails_helper'

RSpec.describe "ScheduledWorkdays", type: :request do
  describe "GET /create" do
    it "returns http success" do
      get "/scheduled_workdays/create"
      expect(response).to have_http_status(:success)
    end
  end

end
