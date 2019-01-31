class UnsubscribeController < ApplicationController
  def index
  end
  def execute
    redirect_to :controller => '/unsubscribe_comp'
  end
end
