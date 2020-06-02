class Admin::UsersController < ApplicationController
  before_action :if_not_admin, only: [ :index, :edit, :update, :destroy]
  before_action :set_user, only: [:show, :edit, :update, :destroy]


  def index
    @users = User.all.includes(:tasks).all.order(created_at: :desc)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect_to admin_user_path(@user.id), notice: "ユーザーを作成しました"
    else
      render :new
    end
  end

  def show
    @tasks = Task.all
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to admin_users_path(@user), notice:"ユーザー「#{@user.name}」を編集しました"
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      redirect_to admin_users_path, notice:"ユーザー「#{@user.name}」を削除しました"
    else
      redirect_to admin_users_path, notice:"ユーザー「#{@user.name}」を削除できません"
    end
  end

  private

  def if_not_admin
    unless current_user.admin?
      flash[:notice] = 'あなたは管理者ではありません'
      redirect_to root_path
    end
  end

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation, :admin)
  end

end
