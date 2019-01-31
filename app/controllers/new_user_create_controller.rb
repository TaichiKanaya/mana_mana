class NewUserCreateController < ApplicationController
  skip_before_action :require_login
  def index
    
  end
  def create
    redirect_to '/new_user_temp_create_comp'
  end
end
