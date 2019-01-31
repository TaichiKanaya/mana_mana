class UnsubscribeCompController < ApplicationController
  skip_before_action :require_login
  def index
  end
  def login
    redirect_to :controller => 'login'
  end
end
