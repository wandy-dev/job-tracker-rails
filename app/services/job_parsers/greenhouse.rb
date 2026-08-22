module JobParsers
  class Greenhouse < Base
    def self.can_parse?(url)
      uri = URI.parse(url)
      uri.host&.include?("greenhouse.io")
    end

    def parse
      doc = fetch_html

      title = doc.at("meta[property='og:title']")&.[]('content')
      location = doc.at("meta[property='og:description']")&.[]('content')
      
      # Extract company from the main <title> tag. 
      # Format is usually: "Job Application for {Title} at {Company}"
      page_title = doc.title || ""
      company_name = if title && page_title.include?(" at ")
        page_title.sub(/^Job Application for #{Regexp.escape(title)}\s*at\s*/i, '').strip
      else
        @uri.path.split('/')[1]&.capitalize || "Unknown Company"
      end

      {
        title: title,
        company_name: company_name,
        location: location,
        url: @url,
        source: 'greenhouse'
      }
    end
  end
end
