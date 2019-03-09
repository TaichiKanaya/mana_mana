class Category < ActiveRecord::Base
  has_many :questions
  has_many :user_access_categories
  has_many :users, through: :user_access_categories
end