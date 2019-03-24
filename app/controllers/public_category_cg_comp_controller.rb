class PublicCategoryCgCompController < ApplicationController
  def index
    @category = Category.where("id = ? and all_share_flg = 1", params[:category_id]).first
    @goodCount = Category
      .left_outer_joins(:good_categories)
      .select("count(good_categories.id) goods")
      .where("categories.id = ? and categories.all_share_flg = 1", params[:category_id])
      .group("categories.id")
      .first.goods
    goodCategoryRecords = Category.joins(:good_categories)
      .where("categories.id = ? and categories.all_share_flg = 1 and good_categories.created_user_id = ?", params[:category_id], session[:id])
      .first
    if goodCategoryRecords.blank?
      @isGoodAble = true
    else
      @isGoodAble = false
    end
  end

  def comp
    redirect_to :controller => "/public_category_list"
  end
  
  def good
    @category = Category.where("id = ? and all_share_flg = 1", params[:category_id]).first
    if @category.blank?
      raise
      return
    end
    
    goodCategoryRecords = Category.joins(:good_categories)
      .where("categories.id = ? and categories.all_share_flg = 1 and good_categories.created_user_id = ?", params[:category_id], session[:id])
      .first
    if ! goodCategoryRecords.blank?
      raise
      return
    end
    
    goodCategoryRecord = GoodCategory.new
    goodCategoryRecord.user_id = session[:id]
    goodCategoryRecord.category_id = params[:category_id]
    goodCategoryRecord.created_at = Time.new.strftime("%Y-%m-%d %H:%M:%S")
    goodCategoryRecord.created_user_id = session[:id]
    goodCategoryRecord.save!
    
    redirect_to "/public_categroy_cg_comp?category_id=" + params[:category_id]
  end
end
