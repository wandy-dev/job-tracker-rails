module Jobs
  class StatusAdvancementsController < ApplicationController
    def create
      @job = Job.find(params[:job_id])
      
      if @job.advance_status!
        redirect_to job_path(@job), notice: "Stage marked as complete. Moved to #{@job.status.titleize}!"
      else
        redirect_to job_path(@job), alert: "Cannot advance status further."
      end
    end
  end
end
