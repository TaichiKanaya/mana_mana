class User < ActiveRecord::Base
  has_secure_password
  has_many :user_access_categories
end