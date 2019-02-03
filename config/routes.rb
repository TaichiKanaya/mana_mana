Rails.application.routes.draw do
# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # ログイン
  get 'login' => 'login#index'
  post 'login/login' => 'login#login'

  # 利用規約
  get 'use_rule' => 'use_rule#index'

  # ユーザ無料登録
  get 'new_user_create' => 'new_user_create#index'
  post 'new_user_create/create' => 'new_user_create#create'

  # ユーザ仮登録完了
  get 'new_user_temp_create_comp' => 'new_user_temp_create_comp#index'
  post 'new_user_temp_create_comp/login' => 'new_user_temp_create_comp#login'

  # パスワード変更
  get 'pw_chg' => 'pw_chg#index'
  post 'pw_chg/change' => 'pw_chg#change'

  # パスワード変更完了
  get 'pw_chg_comp' => 'pw_chg_comp#index'
  post 'pw_chg_comp/login' => 'pw_chg_comp#login'

  # パスワードリセット
  get 'pw_reset' => 'pw_reset#index'
  post 'pw_reset/reset' => 'pw_reset#reset'

  # パスワードリセット完了
  get 'pw_reset_comp' => 'pw_reset_comp#index'
  post 'pw_reset_comp/login' => 'pw_reset_comp#login'

  # プライバシーポリシー
  get 'privacy_policy' => 'privacy_policy#index'

  # トップメニュー
  get 'top' => 'top#index'

  # 問題一覧
  get 'qs_list' => 'qs_list#index'
  get 'qs_list/search' => 'qs_list#search'
  post 'qs_list/search' => 'qs_list#search'
  get 'qs_list/outputCsv' => 'qs_list#outputCsv'
  post 'qs_list/outputCsv' => 'qs_list#outputCsv'

  # 問題登録
  get 'qs_reg' => 'qs_reg#index'
  post 'qs_reg/create' => 'qs_reg#create'

  # 問題更新
  get 'qs_upd' => 'qs_upd#index'
  post 'qs_upd/update' => 'qs_upd#update'
  patch 'qs_upd/update' => 'qs_upd#update'
  delete 'qs_upd/delete' => 'qs_upd#delete'

  # 問題削除完了
  get 'qs_del_comp' => 'qs_del_comp#index'

  # カテゴリ管理
  get 'ctg_mng' => 'ctg_mng#index'
  post 'ctg_mng/update' => 'ctg_mng#update'
  post 'ctg_mng/delete' => 'ctg_mng#delete'

  # カテゴリ選択
  get 'ctg_sel' => 'ctg_sel#index'
  post 'ctg_sel/start' => 'ctg_sel#start'

  # チャレンジ問題
  get 'cg' => 'cg#index'

  # チャレンジ問題終了
  get 'cg_comp' => 'cg_comp#index'
  post 'cg_comp/comp' => 'cg_comp#comp'

  # お知らせ管理
  get 'info_mng' => 'info_mng#index'
  post 'info_mng/update' => 'info_mng#update'

  # 退会
  get 'unsubscribe' => 'unsubscribe#index'
  post 'unsubscribe/execute' => 'unsubscribe#execute'

  # 退会完了
  get 'unsubscribe_comp' => 'unsubscribe_comp#index'
  post 'unsubscribe_comp/login' => 'unsubscribe_comp#login'
end
