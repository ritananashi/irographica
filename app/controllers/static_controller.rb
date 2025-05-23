class StaticController < ApplicationController
  def home
    @category = Category.all
  end

  def contact; end
end
