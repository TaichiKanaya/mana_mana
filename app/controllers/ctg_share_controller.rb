class CtgShareController < ApplicationController
  def index
    @sharedUserRecords = UserAccessCategory.left_outer_joins(:user).select("user_access_categories.id record_id, users.mail_address, users.name").where(category_id: params[:category_id])
  end
  def share
    flash[:notice] = []
    flash[:error] = []
    check_param
    
    unless flash[:error].length > 0 then
      shareUser = User.find_by(mail_address: params[:mailAddress], birthday: params[:birthday])
      if shareUser.blank? then
        flash[:error] << 'メールアドレスまたは生年月日が間違っています'
      end
    end

    if flash[:error].length > 0 then
      init
      render action: :index
      return
    end
    
    userAccessCategory = UserAccessCategory.new
    userAccessCategory.user = shareUser
    userAccessCategory.category_id = params[:category_id]
    userAccessCategory.created_at = Time.new.strftime("%Y-%m-%d %H:%M:%S")
    userAccessCategory.created_user_id = session[:id]
    userAccessCategory.save!
    flash[:notice] << '登録が完了しました。'
    redirect_to createRedirectUrl
  end
  
  def delete
    record = UserAccessCategory.find_by(id:params[:del_record_id], created_user_id: session[:id])
    record.destroy!
    flash[:notice] = ["シェアの取り消しが完了しました"]
    redirect_to createRedirectUrl
  end
  
  private
  def init
    @sharedUserRecords = UserAccessCategory.left_outer_joins(:user).select("user_access_categories.id record_id, users.mail_address, users.name").where(category_id: params[:category_id])
  end
  def createRedirectUrl
    return "/ctg_share?category_id=" + params[:category_id].to_s
  end
  def check_param
    if params[:mailAddress].blank?
      flash[:error] << "メールアドレスを入力してください"
    else
      valid_address = /\A[a-zA-Z0-9_\#!$%&`'*+\-{|}~^\/=?\.]+@[a-zA-Z0-9][a-zA-Z0-9\.-]+\z/
      unless valid_address =~ params[:mailAddress] then
        flash[:error] << "メールアドレスの形式が正しくありません"
      end
    end
    if params[:birthday].blank?
      flash[:error] << "生年月日を入力してください"
    end
  end
end
