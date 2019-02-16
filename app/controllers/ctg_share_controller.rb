class CtgShareController < ApplicationController
  def index
    @sharedUserRecords = UserAccessCategories.left_outer_joins(:user).select("user_access_categories.id record_id, users.user_id mail_address, users.user_name").where(category_id: params[:category_id])
  end
  def share
    flash[:notice] = []
    flash[:error] = []
    check_param
    
    unless flash[:error].length > 0 then
      shareUser = User.find_by(user_id: params[:mailAddress], birthday: params[:birthday])
      if shareUser.blank? then
        flash[:error] << 'メールアドレスまたは生年月日が間違っています'
      end
    end

    if flash[:error].length > 0 then
      init
      render action: :index
      return
    end
    
    userAccessCategoriy = UserAccessCategories.new 
    userAccessCategoriy.user_id = shareUser.id
    userAccessCategoriy.category_id = params[:category_id]
    userAccessCategoriy.reg_date = Time.new.strftime("%Y-%m-%d %H:%M:%S")
    userAccessCategoriy.reg_user_id = session[:id]
    userAccessCategoriy.save!
    flash[:notice] << '登録が完了しました。'
    redirect_to createRedirectUrl
  end
  
  def delete
    record = UserAccessCategories.find_by(id:params[:del_record_id], reg_user_id: session[:id])
    record.destroy!
    flash[:notice] = ["シェアの取り消しが完了しました"]
    redirect_to createRedirectUrl
  end
  
  private
  def init
    @sharedUserRecords = UserAccessCategories.left_outer_joins(:user).select("user_access_categories.id record_id, users.user_id mail_address, users.user_name").where(category_id: params[:category_id])
  end
  def createRedirectUrl
    return "/ctg_share?category_id=" + params[:category_id].to_s
  end
  def check_param
    if params[:mailAddress].empty?
      flash[:error] << "メールアドレスを入力してください"
    else
      valid_address = /\A[a-zA-Z0-9_\#!$%&`'*+\-{|}~^\/=?\.]+@[a-zA-Z0-9][a-zA-Z0-9\.-]+\z/
      unless valid_address =~ params[:mailAddress] then
        flash[:error] << "メールアドレスの形式が正しくありません"
      end
    end
    if params[:birthday].empty?
      flash[:error] << "生年月日を入力してください"
    end
  end
end
