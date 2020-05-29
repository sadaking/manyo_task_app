class UsersController < ApplicationController

  def new
    unless session[:user_id] == nil
      redirect_to user_path(session[:user_id]), notice: 'すでにユーザーが作成されています'
    else
      @user = User.new
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect_to user_path(@user.id), notice: "ユーザーを作成しました"
    else
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to tasks_path, notice: '他の人のページへアクセスは出来ません'
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end
end
