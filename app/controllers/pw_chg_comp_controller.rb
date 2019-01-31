class PwChgCompController < ApplicationController
  def index
  end
  def login
    redirect_to :controller => "/login"
  end
end
