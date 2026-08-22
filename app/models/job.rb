class Job < ApplicationRecord
  belongs_to :company
  has_many :activities, dependent: :destroy

  enum :status, { wishlist: 0, preparing: 1, applied: 2, interviewing: 3, offered: 4, rejected: 5, withdrawn: 6, ghosted: 7 }, default: :wishlist

  HAPPY_PATH_STATUSES = %w[wishlist preparing applied interviewing offered].freeze

  def advance_status!
    current_index = HAPPY_PATH_STATUSES.index(status)
    
    if current_index && current_index < HAPPY_PATH_STATUSES.length - 1
      update!(status: HAPPY_PATH_STATUSES[current_index + 1])
    else
      false
    end
  end

  def reject!
    update!(status: :rejected)
  end

  def ghost!
    update!(status: :ghosted)
  end

  def withdraw!
    update!(status: :withdrawn)
  end
end
