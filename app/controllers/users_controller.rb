class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :only_administrador, only: [:index, :new, :create, :destroy]

  def index
    @users = User.all
  end


  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to users_path, notice: t("users.create.success")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to users_path, notice: t(".success")
  rescue ActiveRecord::RecordNotDestroyed
    redirect_to @user, alert: "Exclusão de Usuário falhou"
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :role)
  end

  def only_administrador
    redirect_to root_path, alert: t("users.only_administrador.unauthorized") unless current_user.administrador?
  end
end
