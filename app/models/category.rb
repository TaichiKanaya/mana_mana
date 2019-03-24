class Category < ActiveRecord::Base
  belongs_to :user, :foreign_key => "created_user_id"
  has_many :questions
  has_many :user_access_categories
  has_many :users, through: :user_access_categories
  has_many :good_categories
end