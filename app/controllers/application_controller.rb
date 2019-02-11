class ApplicationController < ActionController::Base
  before_action :require_login

  private
  def require_login
    unless session[:id]
      redirect_to '/login'
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
