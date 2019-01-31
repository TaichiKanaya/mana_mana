#= お知らせ管理処理クラス
#Author:: Taichi.kanayua
#Copyright:: © 2018 Taichi.Kanaya
class InfoMngController < ApplicationController
  #初期表示
  def index
    @informations = Informations.all
    puts @informations.inspect
    params[:title] = []
    params[:contents] = []
    @informations.each_with_index do |information, index|
      params[:title][index] = information.title
      params[:contents][index] = information.contents
    end
  end

  #更新処理
  def update
    puts params.inspect

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
        @resultInformation.title = params[:title][index]
        @resultInformation.contents = params[:contents][index]
        @resultInformation.upd_date = Time.new.strftime("%Y-%m-%d %H:%M:%S")
      @resultInformation.upd_user_id = 1
      @resultInformation.save
      else
        @informations = Informations.new
        @informations.id = params[:information_id][index]
        @informations.title = params[:title][index]
        @informations.contents = params[:contents][index]
        @informations.reg_date = Time.new.strftime("%Y-%m-%d %H:%M:%S")
      @informations.reg_user_id = 1
      @informations.save
      end

    end
    flash[:error] = nil
    flash[:notice] = ["お知らせの更新が完了しました"]
    redirect_to action: :index
  end

  # 入力パラメータチェック
  def checkParam
    # 文字数チェック
    flash[:error] = []
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

end
