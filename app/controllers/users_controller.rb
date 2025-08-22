class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :only_admin, only: [ :new, :create ]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to users_path, notice: "Usuário criado"
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :role)
  end

  def only_admin
    redirect_to root_path, alert: "Somente administrador autorizado" unless current_user.admin?
  end
end
