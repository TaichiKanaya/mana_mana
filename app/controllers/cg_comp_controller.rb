class CgCompController < ApplicationController
  def index
  end

  def comp
    redirect_to :controller => "/ctg_sel"
  end
end
