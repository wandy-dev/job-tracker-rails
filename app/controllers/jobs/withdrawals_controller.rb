module Jobs
  class WithdrawalsController < ApplicationController
    def create
      @job = Job.find(params[:job_id])
      
      @job.withdraw!
      redirect_to job_path(@job), notice: "Job marked as withdrawn."
    end
  end
end
