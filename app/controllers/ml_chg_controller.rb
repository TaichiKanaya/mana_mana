class MlChgController < ApplicationController
  def index
  end

  def change
    flash[:error] = []
    check_param
    
    unless flash[:error].length > 0 then
      result = User.find_by(mail_address: params[:newMailAddress])
      check_user result
    end
    
    if flash[:error].length > 0 then
      render action: :index
      return
    end
    
    user = User.find_by(id: session[:id])
    user.mail_address = params[:newMailAddress]
    user.updated_user_id = session[:id]
    user.updated_at = Time.new.strftime("%Y-%m-%d %H:%M:%S")
    user.save
    
    session[:mail_address] = params[:newMailAddress]
    
    redirect_to '/ml_chg_comp'
  end

  private

  def check_param
    if params[:newMailAddress].blank?
      flash[:error] << "メールアドレスを入力してください"
    else
      valid_address = /\A[a-zA-Z0-9_\#!$%&`'*+\-{|}~^\/=?\.]+@[a-zA-Z0-9][a-zA-Z0-9\.-]+\z/
      unless valid_address =~ params[:newMailAddress] then
        flash[:error] << "メールアドレスの形式が正しくありません"
      end
    end
  end

  def check_user target
    if target then
      flash[:error] << "このメールアドレスは既に登録済のため、変更できません"
    end
  end

end
