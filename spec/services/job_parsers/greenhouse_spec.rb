require 'rails_helper'

RSpec.describe JobParsers::Greenhouse do
  describe ".can_parse?" do
    it "returns true for greenhouse.io URLs" do
      expect(JobParsers::Greenhouse.can_parse?("https://job-boards.greenhouse.io/gitlab/jobs/123")).to be_truthy
      expect(JobParsers::Greenhouse.can_parse?("https://boards.greenhouse.io/github/jobs/123")).to be_truthy
    end

    it "returns false for other URLs" do
      expect(JobParsers::Greenhouse.can_parse?("https://jobs.lever.co/company/123")).to be_falsey
    end
  end

  describe "#parse" do
    let(:url) { "https://job-boards.greenhouse.io/gitlab/jobs/123" }
    let(:parser) { JobParsers::Greenhouse.new(url) }
    
    before do
      # Stub the fetch_html method to return Nokogiri document from string
      allow(parser).to receive(:fetch_html).and_return(Nokogiri::HTML(html_content))
    end

    context "with modern meta tags" do
      let(:html_content) do
        <<~HTML
          <html>
            <head>
              <title>Job Application for Staff Engineer at GitLab</title>
              <meta property="og:title" content="Staff Engineer" />
              <meta property="og:description" content="Remote, UK" />
            </head>
          </html>
        HTML
      end

      it "extracts title, location, and company from meta tags and title" do
        result = parser.parse

        expect(result[:title]).to eq("Staff Engineer")
        expect(result[:location]).to eq("Remote, UK")
        expect(result[:company_name]).to eq("GitLab")
        expect(result[:url]).to eq(url)
        expect(result[:source]).to eq("greenhouse")
      end
    end

    context "with fallback parsing when meta tags are incomplete" do
      let(:html_content) do
        <<~HTML
          <html>
            <head>
              <title>Some weird title</title>
            </head>
          </html>
        HTML
      end

      it "falls back to extracting company from URL path" do
        result = parser.parse
        
        expect(result[:title]).to be_nil
        expect(result[:location]).to be_nil
        expect(result[:company_name]).to eq("Gitlab") # Capitalized from path
      end
    end
  end
end
