class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :mail_address
      t.string :name
      t.string :password_digest
      t.date :birthday
      t.integer :temp_regist_flg
      t.integer :password_init_flg
      t.timestamp :password_init_updated_at
      t.integer :created_user_id
      t.integer :updated_user_id

      t.timestamps
    end
  end
end
