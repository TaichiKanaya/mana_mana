#= お知らせ管理処理クラス
#Author:: Taichi.Kanaya
#Copyright:: © 2018 Taichi.Kanaya
class InfoMngController < ApplicationController
  #初期表示
  def index
    @informations = Informations.all
    params[:announceDate] = []
    params[:title] = []
    params[:contents] = []
    @informations.each_with_index do |information, index|
      params[:announceDate][index] = information.announce_date
      params[:title][index] = information.title
      params[:contents][index] = information.contents
    end
  end

  #更新処理
  def update
    # 入力パラメータチェック
    checkParam
    if flash[:error].length > 0
      render action: :index
    return
    end

    #お知らせテーブル更新処理
    params[:title].each_with_index do |element, index|
      @resultInformation = Informations.find_by id:params[:information_id][index]
      if @resultInformation
        p "resultInformation"
        p @resultInformation
        p "parammsdkdkdkdkdk"
        p params.inspect
        p params[:announceDate][index]
        @resultInformation.announce_date = params[:announceDate][index]
        @resultInformation.title = params[:title][index]
        @resultInformation.contents = params[:contents][index]
        @resultInformation.upd_date = Time.new.strftime("%Y-%m-%d %H:%M:%S")
        @resultInformation.upd_user_id = 1
        @resultInformation.save!
      else
        @informations = Informations.new
        @informations.id = params[:information_id][index]
        @informations.announce_date = params[:announceDate][index]
        @informations.title = params[:title][index]
        @informations.contents = params[:contents][index]
        @informations.reg_date = Time.new.strftime("%Y-%m-%d %H:%M:%S")
        @informations.reg_user_id = 1
        @informations.save!
      end

    end
    flash[:error] = nil
    flash[:notice] = ["お知らせの更新が完了しました"]
    redirect_to action: :index
  end

  private

  # 入力パラメータチェック
  def checkParam
    # 文字数チェック
    flash[:error] = []
    params[:announceDate].each_with_index do |element, index|
      if !date_valid?(element)
        flash[:error] << "お知らせ" + (index+1).to_s + "の公開日の書式が正しくありません"
      end
    end
    params[:title].each_with_index do |element, index|
      if element.length > 50
        flash[:error] << "お知らせ" + (index+1).to_s + "のタイトルは50文字以内で入力してください"
      end
    end
    params[:contents].each_with_index do |element, index|
      if element.length > 2000
        flash[:error] << "お知らせ" + (index+1).to_s + "の内容は2000文字以内で入力してください"
      end
    end
  end

  def date_valid?(str)
    if str.blank? then 
      return true 
    else
      return !! Date.parse(str.gsub("/","-")) rescue false
    end
  end
end
