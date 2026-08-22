module Jobs
  class RejectionsController < ApplicationController
    def create
      @job = Job.find(params[:job_id])
      
      @job.reject!
      redirect_to job_path(@job), notice: "Job marked as rejected."
    end
  end
end
