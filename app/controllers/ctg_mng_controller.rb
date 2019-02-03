class CtgMngController < ApplicationController
  # 初期表示
  def index
    @categories = Category.order('id asc').all
    params[:categoryId] = []
    params[:categoryName] = []
    @categories.each_with_index do |category, index|
      params[:categoryId][index] = category.id
      params[:categoryName][index] = category.category_name
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
        record.category_name = params[:categoryName][index]
        record.reg_date = Time.new.strftime("%Y-%m-%d %H:%M:%S")
        record.reg_user_id = 1
        record.save!
      elsif !params[:categoryId][index].blank? && !params[:categoryName][index].blank?
        record = Category.find_by id:params[:categoryId][index]
        record.category_name = params[:categoryName][index]
        record.upd_date = Time.new.strftime("%Y-%m-%d %H:%M:%S")
        record.upd_user_id = 1
        record.save!
      end
    end
    
    flash[:error] = nil
    flash[:notice] = ["カテゴリの更新が完了しました"]
    redirect_to action: :index
  end
  
  # カテゴリ削除
  def delete
    record = Category.find_by id:params[:delCategoryId]
    record.destroy!
    flash[:error] = nil
    flash[:notice] = ["カテゴリの削除が完了しました"]
    redirect_to action: :index
  end

  private

  # 入力パラメータチェック
  def checkParam
    flash[:error] = []
    params[:categoryName].each_with_index do |element, index|
      if element.blank? && !params[:categoryId][index].blank?
        flash[:error] << "カテゴリ名" + (index+1).to_s + "を入力してください"
      end
    end
  end

end
