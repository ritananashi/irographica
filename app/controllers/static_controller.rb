class StaticController < ApplicationController
  def home
    @reviews = Review.includes(:user, :product).order(created_at: "DESC").all
  end
end
