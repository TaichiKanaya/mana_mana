class QsRegController < ApplicationController
  # Initialize Process
  def index
    @questions = Question.new
    init
  end

  # Create Question
  def create
    flash[:notice] = []
    flash[:error] = []
    @questions = Question.new user_params
    unless @questions.valid?
      init
      render action: :index
      return
    end
    
    checkCount
    if flash[:error].length > 0 then
      init
      render action: :index
      return
    end
    
    @questions.created_at = Time.new.strftime("%Y-%m-%d %H:%M:%S")
    @questions.created_user_id = session[:id]
    if @questions.save
      flash[:notice] << '登録が完了しました。'
      redirect_to :controller => "qs_reg"
    else
      flash[:error] << '登録に失敗しました。画面を開き直し、再度やり直してください。'
      init
      render action: :index
    end
  end

  def init
    @categories = Category.where("created_user_id = ?", session[:id])
  end
  
  def checkCount
    questionCount = Question.where("created_user_id = ?", session[:id]).size
    if questionCount >= 1000
      flash[:error] << '問題の最大登録可能件数を超過しています（一人あたり1000件まで）。他の問題を削除して再登録してください。'
    end
  end
    
  # setting strong parameter
  def user_params
    params.require(:question).permit(:category_id, :question, :answer)
  end
end
