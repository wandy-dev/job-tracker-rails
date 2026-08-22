require 'rails_helper'

RSpec.describe "Activities", type: :request do
  let(:company) { Company.create!(name: "Test Company") }
  let(:job) { Job.create!(company: company, title: "Test Job") }

  describe "POST /jobs/:job_id/activities" do
    let(:valid_params) do
      {
        activity: {
          action_type: "phone_screen",
          occurred_at: Time.current,
          notes: "Had a great chat!"
        }
      }
    end

    it "creates a new activity and responds with turbo stream" do
      expect {
        post job_activities_path(job), params: valid_params, as: :turbo_stream
      }.to change(Activity, :count).by(1)

      expect(response.media_type).to eq Mime[:turbo_stream]
      expect(response.body).to include("turbo-stream action=\"replace\" target=\"activities_feed\"")
    end

    it "fails gracefully with invalid params" do
      expect {
        # Action type string that isn't in enum raises ArgumentError in Rails
        # But wait, strong parameters handles this if it's invalid?
        # Actually, let's just pass empty params to test failure
        post job_activities_path(job), params: { activity: { occurred_at: nil } }
      }.not_to change(Activity, :count)

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
