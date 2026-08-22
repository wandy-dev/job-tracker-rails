class JobsController < ApplicationController
  def index
    @jobs = Job.includes(:company).order(created_at: :desc)
  end

  def new
  end

  def create
    url = params[:url]

    if url.blank?
      flash[:alert] = "Please provide a valid URL"
      render :new, status: :unprocessable_entity
      return
    end

    begin
      job = ::JobCreationService.create_from_url!(url)
      redirect_to job_path(job), notice: "Job successfully added from URL!"
    rescue => e
      flash[:alert] = "Error parsing job: #{e.message}"
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @job = Job.find(params[:id])
    @activities = @job.activities.order(occurred_at: :desc)
  end

  def destroy
    @job = Job.find(params[:id])
    @job.destroy
    redirect_to jobs_path, notice: "Job was successfully deleted."
  end
end
