class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable

  has_many :polls

  enum :role, { usuario: 0, administrador: 1 }

  before_destroy :handle_polls_on_destroy

  private

  def handle_polls_on_destroy
    polls.update_all(status: :closed, user_id: nil)
  end
end
