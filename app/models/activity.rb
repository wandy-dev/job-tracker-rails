class Activity < ApplicationRecord
  belongs_to :job

  validates :action_type, :occurred_at, presence: true

  enum :action_type, { email_received: 0, email_sent: 1, phone_screen: 2, technical_interview: 3, behavioral_interview: 4, take_home_assignment: 5, offer_received: 6 }, default: :email_received
end
