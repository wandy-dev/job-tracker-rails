require 'rails_helper'

RSpec.describe JobsHelper, type: :helper do
  describe "#chevron_step_class" do
    let(:job) { Job.new(status: "applied") }
    # happy path: wishlist (0), preparing (1), applied (2), interviewing (3), offered (4)

    it "returns 'chevron-step completed' for previous steps" do
      expect(helper.chevron_step_class(job, 0)).to eq("chevron-step completed")
      expect(helper.chevron_step_class(job, 1)).to eq("chevron-step completed")
    end

    it "returns 'chevron-step current' for the current step" do
      expect(helper.chevron_step_class(job, 2)).to eq("chevron-step current")
    end

    it "returns 'chevron-step' for future steps" do
      expect(helper.chevron_step_class(job, 3)).to eq("chevron-step")
      expect(helper.chevron_step_class(job, 4)).to eq("chevron-step")
    end

    it "returns 'chevron-step' for all steps if job is in a terminal state" do
      job.status = "rejected"
      expect(helper.chevron_step_class(job, 2)).to eq("chevron-step")
    end
  end

  describe "#can_advance_job?" do
    it "returns true when job is in a happy path state and not at the end" do
      job = Job.new(status: "applied")
      expect(helper.can_advance_job?(job)).to be_truthy
    end

    it "returns false when job is at the end of the happy path" do
      job = Job.new(status: "offered")
      expect(helper.can_advance_job?(job)).to be_falsey
    end

    it "returns false when job is in a terminal state" do
      job = Job.new(status: "rejected")
      expect(helper.can_advance_job?(job)).to be_falsey
    end
  end

  describe "#show_terminal_buttons?" do
    it "returns true for active jobs" do
      job = Job.new(status: "applied")
      expect(helper.show_terminal_buttons?(job)).to be_truthy
    end

    it "returns false for terminal jobs" do
      ["rejected", "ghosted", "withdrawn"].each do |status|
        job = Job.new(status: status)
        expect(helper.show_terminal_buttons?(job)).to be_falsey
      end
    end
  end
end
