class CreateQuestions < ActiveRecord::Migration[5.2]
  def change
    create_table :questions do |t|
      t.integer :category_id
      t.text :question
      t.text :answer
      t.integer :created_user_id
      t.integer :updated_user_id

      t.timestamps
    end
  end
end
