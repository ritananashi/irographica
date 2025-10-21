class BrandsController < ApplicationController
  def index
    @brands = Brand.includes(products: :reviews).all
  end
end
