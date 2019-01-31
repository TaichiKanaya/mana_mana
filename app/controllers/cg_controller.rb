class CgController < ApplicationController
  def index
    @questions = Questions.where(category_id: params[:category_id])
    @questions.load.each do |record|
      @question = record
      return
    end
  end
end
