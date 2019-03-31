class RankingListController < ApplicationController
  def index
    @categories = User.left_outer_joins(:good_categories)
      .select("users.name created_user_name, users.created_at created_at, count(good_categories.id) goods")
      .group("users.name, users.created_at")
      .having('count(good_categories.id) > 0')
      .order("goods desc, users.created_at asc")
      .limit(10)
  end
end
