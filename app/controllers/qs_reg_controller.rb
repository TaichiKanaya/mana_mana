class QsRegController < ApplicationController
  # Initialize Process
  def index
    @questions = Question.new
    init
  end

  # Create Question
  def create
    @questions = Question.new user_params
    unless @questions.valid?
      init
      render action: :index
      return
    end
    @questions.created_at = Time.new.strftime("%Y-%m-%d %H:%M:%S")
    @questions.created_user_id = session[:id]
    if @questions.save
      flash[:notice] = []
      flash[:notice] << '登録が完了しました。'
      redirect_to :controller => "qs_reg"
    else
      flash[:error] = []
      flash[:error] << '登録に失敗しました。画面を開き直し、再度やり直してください。'
      init
      render action: :index
    end
  end

  def init
    @categories = Category.where("created_user_id = ?", session[:id])
  end
    
  # setting strong parameter
  def user_params
    params.require(:question).permit(:category_id, :question, :answer)
  end
end
