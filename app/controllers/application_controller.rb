class ApplicationController < ActionController::Base
  before_action :require_login
  http_basic_authenticate_with :name => ENV['BASIC_AUTH_USERNAME'], :password => ENV['BASIC_AUTH_PASSWORD'] if Rails.env == "staging"
  private
  def require_login
    if session[:id].blank?
      redirect_to '/login'
      return
    end
    userRecord = User.find_by(id: session[:id])
    @adminFlg = false;
    if userRecord.admin_flg == 1 then
      @adminFlg = true
    end
    
    if !@adminFlg then
      if request.fullpath =~ /info_mng/ then
        redirect_to '/404.html'
      end
    end
  end
  
end
