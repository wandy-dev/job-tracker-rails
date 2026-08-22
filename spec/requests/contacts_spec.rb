require 'rails_helper'

RSpec.describe "Contacts", type: :request do
  let(:company) { Company.create!(name: "Test Company") }

  describe "POST /companies/:company_id/contacts" do
    let(:valid_params) do
      {
        contact: {
          name: "John Doe",
          title: "Recruiter",
          email: "john@example.com",
          phone: "555-1234",
          notes: "Nice guy"
        }
      }
    end

    it "creates a new contact and responds with turbo stream" do
      expect {
        post company_contacts_path(company), params: valid_params, as: :turbo_stream
      }.to change(Contact, :count).by(1)

      expect(response.media_type).to eq Mime[:turbo_stream]
      expect(response.body).to include("turbo-stream action=\"replace\" target=\"contacts_feed\"")
    end

    it "fails gracefully with invalid params" do
      expect {
        post company_contacts_path(company), params: { contact: { name: nil } }
      }.not_to change(Contact, :count)

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "DELETE /companies/:company_id/contacts/:id" do
    let!(:contact) { Contact.create!(company: company, name: "Jane Doe") }

    it "deletes the contact and responds with turbo stream" do
      expect {
        delete company_contact_path(company, contact), as: :turbo_stream
      }.to change(Contact, :count).by(-1)

      expect(response.media_type).to eq Mime[:turbo_stream]
      expect(response.body).to include("turbo-stream action=\"replace\" target=\"contacts_feed\"")
    end
  end
end
