# = 問題一覧処理クラス
# Author:: Taichi.Kanaya
# Copyright:: © 2018 Taichi.Kanaya
require 'active_support/core_ext/string'

class QsListController < ApplicationController
  private

  # 検索モード_検索結果表示用
  SEARCH_MODE_OUTPUT = 1

  # 検索モード_CSV出力用
  SEARCH_MODE_CSV = 2

  public
  # 初期表示
  def index
    init
    @questions = Question.new
  end

  # 問題検索
  def search
    init
    exeSearch SEARCH_MODE_OUTPUT
    render action: :index
  end

  # CSV出力
  def outputCsv
    exeSearch SEARCH_MODE_CSV
    respond_to do |format|
      format.csv {
        send_data render_to_string, filename: "outputCsv.csv", type: :csv
      }
    end
  end

  # CSV取込
  def uploadCsv
    flash[:error] = []
    if params[:inpFile].blank?
      flash[:error] << "CSVファイルが指定されていません。"
      redirect_to :controller => "/qs_list"
      return
    end
    
    content = {}
    congent = params[:inpFile].read
    
    errors = []
    newCount, updCount, delCount = Question.import(params[:inpFile], session[:id], errors)
    unless errors.blank?
      flash[:error] = errors
      redirect_to :controller => "/qs_list"
      return
    end
    flash[:notice] = []
    flash[:notice] << "取込処理が完了しました。（新規:#{newCount.to_s} 変更:#{updCount.to_s} 削除:#{delCount.to_s})"
    redirect_to :controller => "/qs_list"
  end

  private

  # 検索実行
  # searchMode 1:検索結果表示用検索 2:CSV出力用検索
  def exeSearch(searchMode)
    @questions = Question.joins(:category).select("questions.*, categories.name")
    @questions = @questions.where("questions.created_user_id = ?", session[:id].to_s)
    generateConditions searchMode
    @questions = @questions.order("categories.name, questions.question")
    # 検索実行
    unless searchMode == SEARCH_MODE_CSV
      @questions = @questions.page(params[:page])
    end
    @condition = params[:condition]
  end

  # 検索条件生成
  # searchMode 1:検索結果表示用検索 2:CSV出力用検索
  def generateConditions(searchMode)

    if searchMode == SEARCH_MODE_OUTPUT
      params_caterogy_id = params[:condition][:category_id]
      params_question = params[:condition][:question]
      params_answer= params[:condition][:answer]
      params_from_created_at= params[:condition][:fromRegDate]
      params_to_created_at= params[:condition][:toRegDate]
    else
      if params[:condition] != nil
        params_caterogy_id = params[:condition][:h_category_id]
        params_question = params[:condition][:h_question]
        params_answer= params[:condition][:h_answer]
        params_from_created_at= params[:condition][:h_fromRegDate]
        params_to_created_at= params[:condition][:h_toRegDate]
      end
    end

    # カテゴリ
    unless params_caterogy_id.blank?
      @questions = @questions.where("category_id = ?", params_caterogy_id.to_s)
    end

    # 問題
    unless params_question.blank?
      @questions = @questions.where("question like ?", "%#{params_question.to_s}%")
    end

    # 解答
    unless params_answer.blank?
      @questions = @questions.where("answer like ?", "%#{params_answer.to_s}%")
    end

    # 登録日時(From)
    fromRegDate = params_from_created_at
    unless fromRegDate.blank?
      if date_valid? fromRegDate
        date = Date.parse(fromRegDate).strftime("%Y-%m-%d %H:%M:%S")
        @questions = @questions.where(" questions.created_at >= ?", date.to_s)
      end
    end

    # 登録日時(To)
    toRegDate = params_to_created_at
    unless toRegDate.blank?
      if date_valid? toRegDate
        date = (Date.parse(toRegDate) + 1).strftime("%Y-%m-%d %H:%M:%S")
        @questions = @questions.where(" questions.created_at < ?", date.to_s)
      end
    end
  end

  # 日付チェック
  def date_valid?(str)
    !!str.to_date rescue false
  end
  
  # 初期処理
  def init
    @categories = Category.where("created_user_id = ?", session[:id])
  end
end
