class StaticController < ApplicationController
  def home
    @pagy, @reviews = pagy(Review.includes(:user, product: :brand).order(created_at: :desc), limit: 10)
    @category = Category.all
  end

  def contact; end
end
