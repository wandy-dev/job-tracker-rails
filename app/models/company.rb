class Company < ApplicationRecord
  has_many :jobs, dependent: :destroy
  has_many :contacts, dependent: :destroy
end
