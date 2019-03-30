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
    @categoryRecords = Category.joins(:user).left_outer_joins(:good_categories)
        .select("categories.id, categories.name category_name, categories.created_at, users.name created_user_name, count(good_categories.id)")
        .where("categories.all_share_flg = 1")
    generateConditions
    @categoryRecords = @categoryRecords.group("categories.id, categories.name, categories.created_at, users.name")
    
    # いいね数の指定がある場合
    params_good = params[:condition][:good]
    unless params_good.blank?
      @categoryRecords = @categoryRecords.having("count(good_categories.id) >= ?", params_good)
    end
    
    @categories = @categoryRecords.page(params[:page])
    @condition = params[:condition]
    render action: :index
  end

  private

  # 検索条件生成
  def generateConditions
    params_category = params[:condition][:category]
    params_user_name = params[:condition][:userName]
    params_from_created_at= params[:condition][:fromRegDate]
    params_to_created_at= params[:condition][:toRegDate]

    # カテゴリ
    unless params_category.blank?
      @categoryRecords = @categoryRecords.where("categories.name like ?", "%#{params_category.to_s}%")
    end
    
    # 登録者名
    unless params_user_name.blank?
      @categoryRecords = @categoryRecords.where("users.name like ?", "%#{params_user_name.to_s}%")
    end

    # 登録日時(From)
    fromRegDate = params_from_created_at
    unless fromRegDate.blank?
      if date_valid? fromRegDate
        date = Date.parse(fromRegDate).strftime("%Y-%m-%d %H:%M:%S")
        @categoryRecords = @categoryRecords.where(" categories.created_at >= ?", date.to_s)
      end
    end

    # 登録日時(To)
    toRegDate = params_to_created_at
    unless toRegDate.blank?
      if date_valid? toRegDate
        date = (Date.parse(toRegDate) + 1).strftime("%Y-%m-%d %H:%M:%S")
        @categoryRecords = @categoryRecords.where(" categories.created_at < ?", date.to_s)
      end
    end
  end

  # 日付チェック
  def date_valid?(str)
    !!str.to_date rescue false
  end
  
end
