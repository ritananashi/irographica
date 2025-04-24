class StaticController < ApplicationController
  def home
    @reviews = Review.includes(:user, :product).order(created_at: "DESC").all
    @category = Category.all
  end

  def contact; end
end
