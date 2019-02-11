class User < ActiveRecord::Base
  has_many :questions
  has_secure_password
end