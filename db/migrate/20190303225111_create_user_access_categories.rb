class CreateUserAccessCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :user_access_categories do |t|
      t.integer :user_id
      t.integer :category_id
      t.integer :created_user_id
      t.integer :updated_user_id
      
      t.timestamps
    end
  end
end
