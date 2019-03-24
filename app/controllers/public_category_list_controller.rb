# 全体にシェアされているカテゴリ一覧処理クラス
# Author:: Taichi.Kanaya
# Copyright:: © 2018 Taichi.Kanaya
require 'active_support/core_ext/string'
class PublicCategoryListController < ApplicationController
  
  # 初期表示
  def index
  end

  # 問題検索
  def search
    @where = "categories.all_share_flg = 1"
    generateConditions
    @categories = Category.joins(:user).left_outer_joins(:good_categories)
      .select("categories.id, categories.name category_name, categories.created_at, users.name created_user_name, count(good_categories.id) goods")
      .where(@where)
      .group("categories.id, categories.name, categories.created_at, users.name")
      .page(params[:page])
    @condition = params[:condition]
    render action: :index
  end

  private

  # 検索条件生成
  def generateConditions
    params_category = params[:condition][:category]
    params_good= params[:condition][:good]
    params_from_created_at= params[:condition][:fromRegDate]
    params_to_created_at= params[:condition][:toRegDate]

    # カテゴリ
    unless params_category.blank?
      whereCategories = params_category.split(" ")
      @where << " and ("
      whereCategories.each_with_index do |whereCategory, index|
        if index != 0
          @where << " or"
        end
        @where << " categories.name like '%" + whereCategory.to_s + "%'"
      end
      @where << ")"
    end

    # いいね数
    unless params_good.blank?
      @where << " and ((select count(*) from good_categories gc where categories.id = gc.category_id) > " + whereGood + ")"
    end

    # 登録日時(From)
    fromRegDate = params_from_created_at
    unless fromRegDate.blank?
      if date_valid? fromRegDate
        date = Date.parse(fromRegDate).strftime("%Y-%m-%d %H:%M:%S")
        @where << " and categories.created_at >= '" + date + "'"
      end
    end

    # 登録日時(To)
    toRegDate = params_to_created_at
    unless toRegDate.blank?
      if date_valid? toRegDate
        date = (Date.parse(toRegDate) + 1).strftime("%Y-%m-%d %H:%M:%S")
        @where << " and categories.created_at < '" + date + "'"
      end
    end
  end

  # 日付チェック
  def date_valid?(str)
    !!str.to_date rescue false
  end
  
end
