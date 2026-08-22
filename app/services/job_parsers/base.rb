require 'net/http'
require 'nokogiri'

module JobParsers
  class Base
    def self.registry
      @registry ||= []
    end

    def self.inherited(subclass)
      super
      registry << subclass
    end

    def self.for(url)
      parser_class = registry.find { |parser| parser.can_parse?(url) }
      raise "Unsupported job board for URL: #{url}" unless parser_class
      
      parser_class.new(url)
    end

    def self.can_parse?(url)
      false
    end

    def initialize(url)
      @url = url
      @uri = URI.parse(url)
    end

    def parse
      raise NotImplementedError, "Subclasses must implement #parse"
    end

    protected

    def fetch_html
      response = fetch_with_redirects(@uri)
      Nokogiri::HTML(response.body)
    end

    private

    def fetch_with_redirects(uri, limit = 3)
      raise "Too many HTTP redirects" if limit == 0

      response = Net::HTTP.get_response(uri)

      case response
      when Net::HTTPSuccess then
        response
      when Net::HTTPRedirection then
        location = response['location']
        fetch_with_redirects(URI(location), limit - 1)
      else
        raise "Failed to fetch job posting: #{response.code}"
      end
    end
  end
end

# In development, Rails lazy-loads classes. 
# We need to explicitly load sibling files so they register themselves!
Dir[File.join(__dir__, '*.rb')].each do |file|
  require_dependency file unless file == __FILE__
end
