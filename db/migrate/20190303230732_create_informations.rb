class CreateInformations < ActiveRecord::Migration[5.2]
  def change
    create_table :informations do |t|
      t.datetime :announce_date
      t.string :title
      t.text :contents
      t.integer :created_user_id
      t.integer :updated_user_id

      t.timestamps
    end
  end
end
