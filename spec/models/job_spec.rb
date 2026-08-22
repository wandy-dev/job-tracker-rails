require 'rails_helper'

RSpec.describe Job, type: :model do
  describe "status methods" do
    let(:company) { Company.create!(name: "Test Company") }
    let(:job) { Job.create!(company: company, title: "Test Job") }

    describe "#advance_status!" do
      it "advances through the happy path" do
        expect(job.status).to eq("wishlist")
        
        job.advance_status!
        expect(job.status).to eq("preparing")
        
        job.advance_status!
        expect(job.status).to eq("applied")
        
        job.advance_status!
        expect(job.status).to eq("interviewing")
        
        job.advance_status!
        expect(job.status).to eq("offered")
      end

      it "returns false when at the end of the happy path" do
        job.update!(status: :offered)
        expect(job.advance_status!).to be_falsey
        expect(job.status).to eq("offered")
      end
      
      it "returns false when in a terminal state" do
        job.update!(status: :rejected)
        expect(job.advance_status!).to be_falsey
      end
    end

    describe "terminal states" do
      it "#reject! updates status to rejected" do
        job.reject!
        expect(job.status).to eq("rejected")
      end

      it "#ghost! updates status to ghosted" do
        job.ghost!
        expect(job.status).to eq("ghosted")
      end

      it "#withdraw! updates status to withdrawn" do
        job.withdraw!
        expect(job.status).to eq("withdrawn")
      end
    end
  end
end
