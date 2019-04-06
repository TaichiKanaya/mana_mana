class QsUpdController < ApplicationController
  def index
    @questions = Question.find_by(id: params[:question_id])
    init
  end

  def update
    flash[:notice] = []
    flash[:error] = []
    @questions = Question.new user_params
    unless @questions.valid?
      init
      render action: :index
    return
    end
    
    checkShare @questions.category_id
    if flash[:error].length > 0 then
      init
      render action: :index
      return
    end
    
    @question = Question.find_by(id: params[:question_id])
    @attributes = {
      category_id:@questions.category_id,
      question: @questions.question,
      answer: @questions.answer,
      updated_at: Time.new.strftime("%Y-%m-%d %H:%M:%S"),
      updated_user_id: session[:id] }

    if @question.update @attributes
      flash[:notice] = []
      flash[:notice] << '更新が完了しました。'
      @questions = Question.find_by(id: params[:question_id])
      redirect_to "/qs_upd/?question_id=" + params[:question_id]
    else
      flash[:error] = []
      flash[:error] << '更新に失敗しました。画面を開き直し、再度やり直してください。'
      init
      render action: :index
    end
  end

  def delete
    flash[:error] = []
    @question = Question.find_by(id: params[:question_id])
    checkShare @question.category_id
    if flash[:error].length > 0 then
      init
      @questions = Question.find_by(id: params[:question_id])
      render action: :index
      return
    end
    @question.delete
    redirect_to "/qs_del_comp"
  end

  def init
    @categories = Category.where("created_user_id = ?", session[:id]).order("name asc")
  end
  
  def checkShare category_id
    categoryRecord = Category.select("id, name, all_share_flg").where("id = ? and created_user_id = ?", category_id, session[:id]).first
    if categoryRecord.all_share_flg == 1
      flash[:error] << "全てのユーザにシェア中のカテゴリ(#{categoryRecord.name})に対して操作できません。シェアを取り消してから操作してください。"
    end
  end

  # setting strong parameter
  def user_params
    params.require(:question).permit(:category_id, :question, :answer)
  end
end
