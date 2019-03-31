class UserAccessCategory < ApplicationRecord
  belongs_to :user, class_name: "User", :foreign_key => "created_user_id"
  belongs_to :shareUser, class_name: "User", :foreign_key => "user_id"
  belongs_to :category, foreign_key: "category_id"
end
