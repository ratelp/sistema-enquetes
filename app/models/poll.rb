class Poll < ApplicationRecord
  belongs_to :user, optional: true
  has_many :poll_options, dependent: :destroy
  has_many :votes, through: :poll_options

  accepts_nested_attributes_for :poll_options, reject_if: :all_blank, allow_destroy: true

  enum :status, { open: 0, closed: 1 }, default: :open
  enum :poll_type, { unica_escolha: 0, multipla_escolha: 1 }

  validates :question, presence: true

  # limita a quantidade votos entre 1 e o número de opções
  validates :max_choices,
            presence: true,
            numericality: {
              only_integer: true, greater_than: 1,
              less_than_or_equal_to: ->(poll) { poll.poll_options.reject(&:marked_for_destruction?).size }
            }, if: :multipla_escolha?


  
  def expired?
    expires_at.present? && expires_at < Time.current
  end
  
  def voted_by?(user)
    return false if user.nil?
    votes.where(user: user).exists?
  end
  
  before_save :set_max_choices_for_unica_escolha

  private

  def set_max_choices_for_unica_escolha
    self.max_choices = 1 if unica_escolha?
  end
end
