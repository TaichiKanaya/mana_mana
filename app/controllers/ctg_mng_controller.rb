class CtgMngController < ApplicationController
  # 初期表示
  def index
    @categories = Category.where(created_user_id: session[:id]).order("name")
    params[:categoryId] = []
    params[:categoryName] = []
    params[:allShareFlg] = []
    params[:onlyShareFlg] = []
    @categories.each_with_index do |category, index|
      params[:categoryId][index] = category.id
      params[:categoryName][index] = category.name
      if category.all_share_flg == 1
        params[:allShareFlg][index] = true
      else
        params[:allShareFlg][index] = false
      end
      userAccessCategory = UserAccessCategory.where("category_id = ?", category.id).first
      if !userAccessCategory.blank?
        params[:onlyShareFlg][index] = true
      else
        params[:onlyShareFlg][index] = false
      end
    end
  end

  # 更新処理
  def update
    # 入力パラメータチェック
    checkParam
    if flash[:error].length > 0
      render action: :index
    return
    end

    # カテゴリテーブル更新処理
    params[:categoryName].each_with_index do |element, index|
      if params[:categoryId][index].blank? && !params[:categoryName][index].blank?
        record = Category.new
        categoryMaxId = Category.maximum("id")
        record.id = categoryMaxId.blank? ? 1 : categoryMaxId + 1
        record.name = params[:categoryName][index]
        record.created_at = Time.new.strftime("%Y-%m-%d %H:%M:%S")
        record.created_user_id = session[:id]
        record.save!
      elsif !params[:categoryId][index].blank? && !params[:categoryName][index].blank?
        record = Category.find_by(id:params[:categoryId][index], created_user_id: session[:id])
        record.name = params[:categoryName][index]
        record.updated_at = Time.new.strftime("%Y-%m-%d %H:%M:%S")
        record.updated_user_id = session[:id]
        record.save!
      end
    end
    
    flash[:error] = nil
    flash[:notice] = ["カテゴリの更新が完了しました"]
    redirect_to action: :index
  end
  
  # カテゴリ削除
  def delete
    record = Question.find_by category_id:params[:delCategoryId]
    if record.blank? then
      record = Category.find_by(id:params[:delCategoryId], created_user_id: session[:id])
      record.destroy!
      flash[:error] = nil
      flash[:notice] = ["カテゴリの削除が完了しました"]
    else
      flash[:error] =  ["すでに問題に使用されているため、このカテゴリは削除できません"]
      flash[:notice] =  nil
    end
    redirect_to action: :index
  end

  private

  # 入力パラメータチェック
  def checkParam
    flash[:error] = []
    if params[:categoryName].blank?
      params[:categoryName] = []
    end
    params[:categoryName].each_with_index do |element, index|
      if element.blank? && !params[:categoryId][index].blank?
        flash[:error] << "カテゴリ名" + (index+1).to_s + "を入力してください"
      end
    end
  end

end
