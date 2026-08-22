require 'rails_helper'

RSpec.describe JobCreationService do
  describe ".create_from_url!" do
    let(:url) { "https://job-boards.greenhouse.io/gitlab/jobs/123" }
    
    before do
      # Mock the parser so we don't actually hit the internet
      dummy_parser = instance_double("JobParsers::Greenhouse", parse: {
        title: "Staff Engineer",
        company_name: "GitLab",
        location: "Remote",
        url: url,
        source: "greenhouse"
      })
      
      allow(JobParsers::Base).to receive(:for).with(url).and_return(dummy_parser)
    end

    it "creates a new company and job when company doesn't exist" do
      expect {
        JobCreationService.create_from_url!(url)
      }.to change(Company, :count).by(1)
       .and change(Job, :count).by(1)

      company = Company.last
      expect(company.name).to eq("GitLab")

      job = Job.last
      expect(job.company).to eq(company)
      expect(job.title).to eq("Staff Engineer")
      expect(job.url).to eq(url)
    end

    it "finds existing company and creates a new job when company exists" do
      existing_company = Company.create!(name: "GitLab", url: "https://gitlab.com")
      
      expect {
        JobCreationService.create_from_url!(url)
      }.to change(Company, :count).by(0)
       .and change(Job, :count).by(1)

      job = Job.last
      expect(job.company).to eq(existing_company)
      expect(job.title).to eq("Staff Engineer")
    end
  end
end
