class CompaniesController < ApplicationController
  def index
    @companies = Company.order(:name)
  end

  def show
    @company = Company.find(params[:id])
    @jobs = @company.jobs.order(created_at: :desc)
    @contacts = @company.contacts.order(:name)
  end

  def destroy
    @company = Company.find(params[:id])
    @company.destroy
    redirect_to companies_path, notice: "Company and all associated jobs were successfully deleted."
  end
end
