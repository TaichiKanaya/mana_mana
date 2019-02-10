class ApplicationController < ActionController::Base
  before_action :require_login

  private
  def require_login
    unless session[:user_id]
      redirect_to '/login'
    end
  end
  
end
