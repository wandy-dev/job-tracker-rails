class ActivitiesController < ApplicationController
  def new
    @job = Job.find(params[:job_id])
    @activity = @job.activities.build(occurred_at: Time.current)
  end

  def create
    @job = Job.find(params[:job_id])
    @activity = @job.activities.build(activity_params)

    if @activity.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to job_path(@job), notice: "Activity logged." }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @activity = Activity.find(params[:id])
    @job = @activity.job
    @activity.destroy
    redirect_to job_path(@job), notice: "Activity deleted."
  end

  private

  def activity_params
    params.require(:activity).permit(:action_type, :occurred_at, :notes)
  end
end
