# = ログイン処理クラス
# Author:: Taichi.Kanaya
# Copyright:: © 2018 Taichi.Kanaya
class LoginController < ApplicationController
  skip_before_action :require_login
  
  public
  def index
    session.clear
    @user = User.new
  end

  def login
    # Check parameter
    flash[:error] = []
    check_param
    
    # Check user
    unless flash[:error].length > 0 then
      user = User.find_by(mail_address: params[:user][:mail_address])
      result = user.authenticate(params[:user][:password])
      check_user result
    end

    # if error is occured, transition to own page
    if flash[:error].length > 0 then
      @user = User.new(user_params)
      render action: :index
      return
    end
    
    setSession user
    if user.password_init_flg == 1 then
      redirect_to :controller => "pw_chg"
    else
      redirect_to :controller => "top"
    end
  end
  
  private
  def check_param
    # mail_address
    if params[:user][:mail_address].blank?
      flash[:error] << "ユーザIDを入力してください"
    end

    # password
    if params[:user][:password].blank?
      flash[:error] << "パスワードを入力してください"
    end
  end

  def check_user target
    unless target then
      flash[:error] << "ユーザIDまたはパスワードが間違っています"
    end
  end
  
  def user_params
    params.require(:user).permit(:mail_address, :password)
  end
  
  def setSession data
    session[:id] = data.id
    session[:mail_address] = data.mail_address
    session[:user_name] = data.name
  end
  
end
