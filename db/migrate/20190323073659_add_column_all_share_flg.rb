class AddColumnAllShareFlg < ActiveRecord::Migration[5.2]
  def change
    add_column :categories, :all_share_flg, :integer
  end
end
