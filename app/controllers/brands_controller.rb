class BrandsController < ApplicationController
  def index
    @brands = Brand.order(products_count: :desc).all
  end
end
