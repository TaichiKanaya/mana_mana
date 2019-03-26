class RankingListController < ApplicationController
  def index
    @categories = User.left_outer_joins(:good_categories)
      .select("users.name created_user_name, count(good_categories.id) goods")
      .group("users.name")
      .having('count(good_categories.id) > 0')
      .order("goods desc")
      .limit(10)
  end
end
