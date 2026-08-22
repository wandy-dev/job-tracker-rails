module Jobs
  class GhostingsController < ApplicationController
    def create
      @job = Job.find(params[:job_id])
      
      @job.ghost!
      redirect_to job_path(@job), notice: "Job marked as ghosted."
    end
  end
end
