require 'rails_helper'

RSpec.describe JobParsers::Base do
  describe ".for" do
    before do
      # Create a dummy parser to test the registry
      stub_const("JobParsers::TestParser", Class.new(JobParsers::Base) do
        def self.can_parse?(url)
          url.include?("test.com")
        end
        
        def parse
          { title: "Test", company_name: "Test Co" }
        end
      end)
    end

    it "returns an instance of the matching parser" do
      parser = JobParsers::Base.for("http://test.com/jobs/123")
      expect(parser).to be_a(JobParsers::TestParser)
    end

    it "raises RuntimeError if no parser matches" do
      expect {
        JobParsers::Base.for("http://unknown.com/jobs/123")
      }.to raise_error(RuntimeError, /Unsupported job board/)
    end
  end
end
