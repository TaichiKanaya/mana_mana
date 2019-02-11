class QsRegController < ApplicationController
  # Initialize Process
  def index
    @questions = Questions.new
  end

  # Create Question
  def create
    @questions = Questions.new user_params
    unless @questions.valid?
      render action: :index
      return
    end
    @questions.reg_date = Time.new.strftime("%Y-%m-%d %H:%M:%S")
    @questions.reg_user_id = session[:id]
    if @questions.save
      flash[:notice] = []
      flash[:notice] << '登録が完了しました。'
      redirect_to :controller => "qs_reg"
    else
      flash[:error] = []
      flash[:error] << '登録に失敗しました。画面を開き直し、再度やり直してください。'
      render action: :index
    end
  end

  # setting strong parameter
  def user_params
    params.require(:questions).permit(:category_id, :question, :answer)
  end
end
