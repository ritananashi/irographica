class ProductsController < ApplicationController
  def index
    @products = Product.includes(:brand).all
  end

  def show
    @product = Product.find_by(params[:id])
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    brand_name = params[:product][:brand_name]
    brand = Brand.find_or_create_by!(name: brand_name)
    @product.brand_id = brand.id

    if @product.save
      flash[:notice] = t('product.new.notice')
      redirect_to products_path
    else
      flash.now[:alert] = t('product.new.alert')
      render :new, status: :unprocessable_entity
    end
  end

  private

  def product_params
    params.require(:product).permit(:name, :brand_id, :category_id)
  end
end
