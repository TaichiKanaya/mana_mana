# = カテゴリ選択処理クラス
# Author:: Taichi.kanayua
# Copyright:: © 2018 Taichi.Kanaya
class CtgSelController < ApplicationController
  def index
    init
  end
  
  def start
    flash[:error] = []
    check_param
    
    unless flash[:error].length > 0 then
      result = Questions.find_by(category_id: params[:category_id])
      if result.nil?
        categoryRecord = Category.find_by(id: params[:category_id], reg_user_id: session[:id])
        flash[:error] << "カテゴリ「" + categoryRecord.category_name + "」には問題が存在していません。先に問題を登録してください"
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
    @categories = Category.where(reg_user_id: session[:id]).or(Category.where("id in (select category_id from user_access_categories where user_id=?)", session[:id]))
  end
  def check_param
    if params[:category_id].empty?
      flash[:error] << "カテゴリを選択してください"
    end
  end
end
