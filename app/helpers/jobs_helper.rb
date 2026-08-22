module JobsHelper
  def chevron_step_class(job, step_index)
    current_index = Job::HAPPY_PATH_STATUSES.index(job.status) || -1
    classes = ["chevron-step"]
    
    if step_index < current_index
      classes << "completed"
    elsif step_index == current_index
      classes << "current"
    end
    
    classes.join(" ")
  end

  def can_advance_job?(job)
    current_index = Job::HAPPY_PATH_STATUSES.index(job.status)
    current_index && current_index < Job::HAPPY_PATH_STATUSES.length - 1
  end

  def show_terminal_buttons?(job)
    !["rejected", "ghosted", "withdrawn"].include?(job.status)
  end
end
