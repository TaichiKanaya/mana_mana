# = カテゴリ選択処理クラス
# Author:: Taichi.Kanaya
# Copyright:: © 2018 Taichi.Kanaya
class CtgSelController < ApplicationController
  def index
    init
  end
  
  def start
    flash[:error] = []
    check_param
    
    unless flash[:error].length > 0 then
      result = Question.find_by(category_id: params[:category_id])
      if result.nil?
        categoryRecord = Category.find_by(id: params[:category_id])
        flash[:error] << "カテゴリ「" + categoryRecord.name + "」には問題が存在していません。先に問題を登録してください。"
      end
    end

    if flash[:error].length > 0 then
      init
      render action: :index
      return
    end
    
    redirect_to :controller => "cg", category_id: params[:category_id]
  end
  
  private
  def init
    @categories = ActiveRecord::Base.connection.execute("select * from " + 
    Category.joins(:user_access_categories).left_outer_joins(:users).
    select("categories.id, categories.name category_name, categories.created_user_id, users.name user_name").
    where("user_access_categories.user_id = ?", session[:id]).
    union(Category.select("categories.id, categories.name, categories.created_user_id, null").
    where("categories.created_user_id = ?", session[:id])).to_sql + " as sub")
  end
  def check_param
    if params[:category_id].blank?
      flash[:error] << "カテゴリを選択してください"
    end
  end
end
