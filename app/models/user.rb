class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable

 
  has_many :polls
  has_many :votes, dependent: :nullify

  enum :role, { usuario: 0, administrador: 1 }

  before_destroy :archive_and_dissociate_polls

  private

  
  def archive_and_dissociate_polls
    polls.update_all(status: :closed, author_email: self.email, user_id: nil)
  end
end
