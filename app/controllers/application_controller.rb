class ApplicationController < ActionController::Base
  before_action :require_login

  private
  def require_login
    puts '*********************'
    puts 'アイウエオ'
    puts '*********************'
    unless session[:user_id]
      redirect_to '/login'
    end
  end
end
