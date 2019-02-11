# = カテゴリ選択処理クラス
# Author:: Taichi.kanayua
# Copyright:: © 2018 Taichi.Kanaya
class CtgSelController < ApplicationController
  def index
    @categories = Category.new
  end
  
  def start
    flash[:error] = []
    check_param
    
    unless flash[:error].length > 0 then
      result = Questions.find_by(category_id: params[:question][:category_id])
      if result.nil?
        categoryRecord = Category.find_by(id: params[:question][:category_id])
        flash[:error] << "カテゴリ「" + categoryRecord.category_name + "」には問題が存在していません。先に問題を登録してください"
      end
    end

    if flash[:error].length > 0 then
      @categories = Category.new
      p params
      render action: :index
      return
    end
    
    redirect_to :controller => "cg", category_id: params[:question][:category_id]
  end
  
  private
  def check_param
    if params[:question][:category_id].empty?
      flash[:error] << "カテゴリを選択してください"
    end
  end
end
