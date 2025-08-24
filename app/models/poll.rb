class Poll < ApplicationRecord
  belongs_to :user
  has_many :poll_options, dependent: :destroy
  has_many :votes, through: :poll_options

  enum status: { open: 0, closed: 1 }
  enum poll_type: { single_choice: 0, multiple_choice: 1 }

  validates :question, presence: true


end
