class ProductsController < ApplicationController
  def index
    @q = params[:q]
    @products = Product.ransack(name_or_brand_name_cont: @q).result(distinct: true).order(:created_at, :id)
  end

  def show
    @product = Product.find(params[:id])
    @reviews = @product.reviews
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

  def search
    @q = params[:q]
    @c = params[:c]
    @products = Product.ransack(name_or_brand_name_cont: @q, category_id_eq: @c).result(distinct: true).
                includes(:brand).order(:created_at, :id)
  end

  private

  def product_params
    params.require(:product).permit(:name, :brand_id, :category_id)
  end
end
