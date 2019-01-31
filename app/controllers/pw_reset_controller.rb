class PwResetController < ApplicationController
  skip_before_action :require_login
  def index
  end
  def reset
    redirect_to '/pw_reset_comp'
  end
end
