# = カテゴリ選択処理クラス
# Author:: Taichi.kanayua
# Copyright:: © 2018 Taichi.Kanaya
class CtgSelController < ApplicationController
  def index
    @categories = Category.new
  end
  
  def start
    redirect_to :controller => "cg", category_id: params[:question][:category_id]
  end
end
