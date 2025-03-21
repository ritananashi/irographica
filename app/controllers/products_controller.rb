class ProductsController < ApplicationController
  def index
    @Products = Product.includes(:brand).all
  end

  def show
    @product = Product.find_by(params[:id])
  end
end
