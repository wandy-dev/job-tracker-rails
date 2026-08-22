module JobsHelper
  def chevron_step_class(job, step_index)
    current_index = Job::HAPPY_PATH_STATUSES.index(job.status) || -1
    classes = ["is-size-7-mobile"]
    
    if step_index < current_index
      classes << "has-text-success has-text-weight-semibold"
    elsif step_index == current_index
      classes << "has-text-link has-text-weight-bold"
    else
      classes << "has-text-grey"
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
