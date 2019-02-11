class PwChgController < ApplicationController
  def index
  end

  def change
    # Check parameter
    flash[:error] = []
    check_param
    
    # Check password
    unless flash[:error].length > 0 then
      user = User.find_by(user_id: session[:user_id])
      result = user.authenticate(params[:nowPassword])
      if !result then
        flash[:error] << "現在のパスワードが正しくありません"
      elsif params[:nowPassword] == params[:newPassword] then
        flash[:error] << "現在のパスワードと新しいパスワードが同じになっています。異なるパスワードにしてください"
      end
      p params[:newPassword]
      validPasswordReg = /\A(?=.*?[a-z])(?=.*?\d)(?=.*?[!-\/:-@\[-`{-~])[!-~]{8,100}+\z/i
      unless validPasswordReg =~ params[:newPassword] then
        flash[:error] << "新しいパスワードは半角英数字記号を全て含む8文字以上100文字以内で設定してください"
      end
    end

    # if error is occured, transition to own page
    if flash[:error].length > 0 then
      render action: :index
      return
    end
    nowDate = Time.new.strftime("%Y-%m-%d %H:%M:%S")
    user.password = params[:newPassword]
    user.temp_regist_flg = 0
    user.password_init_flg = 0
    user.password_init_upd_date = nowDate
    user.upd_user_id = session[:id]
    user.upd_date = nowDate
    user.save
    
    redirect_to '/pw_chg_comp'
  end

  private

  def check_param
    # user_id
    if params[:nowPassword].empty?
      flash[:error] << "現在のパスワードを入力してください"
    end

    # password
    if params[:newPassword].empty?
      flash[:error] << "新しいパスワードを入力してください"
    end
  end
end
