class StaticController < ApplicationController
  def home
    @reviews = Review.includes(:user, :product).all
  end
end
