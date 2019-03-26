class PublicCategoryCgStartController < ApplicationController
  def index
    @category = get_category
  end
  def start
    if get_category.blank?
      raise
      return
    end
    redirect_to "/public_category_cg/?category_id=" + params[:category_id]
  end
  
  private 
  def get_category
    Category.where("id = ? and all_share_flg = 1", params[:category_id]).first
  end
end
