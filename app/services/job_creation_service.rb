class JobCreationService
  def self.create_from_url!(url)
    attributes = JobParsers::Base.for(url).parse

    ActiveRecord::Base.transaction do
      # Find or create the company by name to avoid duplicates
      company = Company.find_or_create_by!(name: attributes[:company_name])
      
      # Create the job tied to this company
      job = company.jobs.create!(
        title: attributes[:title],
        location: attributes[:location],
        url: attributes[:url],
        status: :wishlist # Default status
      )
      
      job
    end
  end
end
