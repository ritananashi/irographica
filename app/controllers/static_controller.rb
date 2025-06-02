class StaticController < ApplicationController
  def home
    @category = Category.all
  end

  def contact; end

  def privacy_policy; end

  def term; end
end
