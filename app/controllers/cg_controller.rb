class CgController < ApplicationController
  def index
    @questions = Questions.left_outer_joins(:user).where("category_id = " + params[:category_id] + " AND users.user_id = '" + session[:user_id] + "'").order("id")
    @questionCount = @questions.length
    session[:question] = []
    @questions.load.each do |record|
      session[:question] << record.id
    end
    session[:questionCount] = 1
    @count = session[:questionCount]

    questionRecord = choiseQuestion
    @question = questionRecord.question
    @answer = questionRecord.answer
  end

  def getQuestion
    if session[:question].empty? then
      return {}
    else
      session[:questionCount] = session[:questionCount].to_i + 1
      questionRecord = choiseQuestion
      jsonQuestion = {'count' => session[:questionCount], 'question' => questionRecord.question, 'answer' => questionRecord.answer}
      render :json => jsonQuestion
    end
  end

  private

  def choiseQuestion
    chosenQuestionId = session[:question].shift
    return Questions.left_outer_joins(:user).select("question, answer").where("questions.id = ? and users.user_id = ?", chosenQuestionId, session[:user_id]).first
  end
end
