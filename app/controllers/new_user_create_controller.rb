class NewUserCreateController < ApplicationController
  skip_before_action :require_login
  def index

  end

  def create
    flash[:error] = []
    check_param
    
    unless flash[:error].length > 0 then
      p params
      result = User.find_by(mail_address: params[:mailAddress])
      check_user result
    end

    if flash[:error].length > 0 then
      render action: :index
      return
    end
    createUser
    redirect_to '/new_user_temp_create_comp'
  end

  private

  def check_param
    if params[:mailAddress].blank?
      flash[:error] << "メールアドレスを入力してください"
    else
      valid_address = /\A[a-zA-Z0-9_\#!$%&`'*+\-{|}~^\/=?\.]+@[a-zA-Z0-9][a-zA-Z0-9\.-]+\z/
      unless valid_address =~ params[:mailAddress] then
        flash[:error] << "メールアドレスの形式が正しくありません"
      end
    end
    if params[:userName].blank?
      flash[:error] << "お名前を入力してください"
    end
    if params[:birthday].blank?
      flash[:error] << "生年月日を入力してください"
    end
    if params[:agree].nil?
      flash[:error] << "利用規約およびプライバシーポリシーに同意いただけない場合はご利用できません"
    end
  end

  def check_user target
    if target then
      flash[:error] << "既にこのメールアドレスは登録されているため、新規登録することはできません"
    end
  end

  def createUser
    nowDate = Time.new.strftime("%Y-%m-%d %H:%M:%S")
    password = [*'A'..'Z', *'a'..'z', *0..9].shuffle[0..7].join

    user = User.new
    user.mail_address = params[:mailAddress]
    user.name = params[:userName]
    user.password = password
    user.birthday = params[:birthday]
    user.temp_regist_flg = 1
    user.password_init_flg = 1
    user.password_init_updated_at = nowDate
    user.admin_flg = 0
    user.created_at = nowDate
    user.created_user_id = 0
    user.save!
    
    NotificationMailer.send_new_temp_user(user, password).deliver
  end
end
