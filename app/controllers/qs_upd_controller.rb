class QsUpdController < ApplicationController
  def index
    @questions = Questions.find_by(id: params[:question_id])
  end

  def update
    puts params
    @questions = Questions.new user_params
    
    unless @questions.valid?
      p @questions.instance_variables
      p "きてるよ"
      render action: :index
    return
    end
    
    @question = Questions.find_by(id: params[:question_id])
    @attributes = {
      category_id:@questions.category_id,
      question: @questions.question,
      answer: @questions.answer,
      upd_date: Time.new.strftime("%Y-%m-%d %H:%M:%S"),
      upd_user_id: session[:id] }

    if @question.update @attributes
      flash[:notice] = []
      flash[:notice] << '更新が完了しました。'
      @questions = Questions.find_by(id: params[:question_id])
      redirect_to "/qs_upd/?question_id=" + params[:question_id]
    else
      flash[:error] = []
      flash[:error] << '更新に失敗しました。画面を開き直し、再度やり直してください。'
      render action: :index
    end
  end

  def delete
    @question = Questions.find_by(id: params[:question_id])
    puts @question.inspect
    @question.delete
    redirect_to "/qs_del_comp"
  end

  # setting strong parameter
  def user_params
    params.require(:questions).permit(:category_id, :question, :answer)
  end
end
