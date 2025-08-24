class Poll < ApplicationRecord
  belongs_to :user, optional: true
  has_many :poll_options, dependent: :destroy
  has_many :votes, through: :poll_options

  accepts_nested_attributes_for :poll_options, reject_if: :all_blank, allow_destroy: true

  enum :status, { open: 0, closed: 1 }, default: :open
  enum :poll_type, { unica_escolha: 0, multipla_escolha: 1 }

  validates :question, presence: true

  before_save :set_max_choices_for_unica_escolha

  private

  def set_max_choices_for_unica_escolha
    self.max_choices = 1 if unica_escolha?
  end
end
