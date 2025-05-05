class ProductsController < ApplicationController
  def index
    if params[:q].blank?
      @q = params[:q]
      @grouping_word = {"0"=>{name_or_brand_name_cont: @q}}
    else
      @q = params[:q].split(/[\s　]/)
      @grouping_word = @q.each_with_index.reduce({}){|hash, (word, i)| hash.merge(i.to_s => { name_or_brand_name_cont: word })}
    end
    @products = Product.ransack({ combinator: "and", groupings: @grouping_word }).
                result(distinct: true).includes(:brand).order(created_at: "DESC")
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
    result = ActiveRecord::Base.transaction do
                brand_name = params[:product][:brand_name]
                brand = Brand.find_or_create_by(name: brand_name)
                if brand.present?
                  @product.brand_id = brand.id
                else
                  raise ActiveRecord::Rollback, t('brand.new.alert')
                end

                if @product.save
                  redirect_to products_path, notice: t('product.new.notice')
                else
                  raise ActiveRecord::Rollback
                end
              end
    unless result
      flash.now[:alert] = t('product.new.alert')
      render :new, status: :unprocessable_entity
    end
  end

  def search
    if params[:q].blank?
      @q = params[:q]
      @grouping_word = {"0"=>{name_or_brand_name_cont: @q}}
    else
      @q = params[:q].split(/[\s　]/)
      @grouping_word = @q.each_with_index.reduce({}){|hash, (word, i)| hash.merge(i.to_s => { name_or_brand_name_cont: word })}
    end
    @c = params[:c]
    @grouping_word["Category_refine"] = { category_id_eq: @c }
    @products = Product.ransack({ combinator: "and", groupings: @grouping_word }).
                result(distinct: true).includes(:brand).order(created_at: "DESC")
  end

  def autocomplete
    @q = params[:q]
    @products = Product.ransack(name_cont: @q).result(distinct: true)
    @brands = Brand.ransack(name_cont: @q).result(distinct: true)
    render layout: "main_only"
  end

  private

  def product_params
    params.require(:product).permit(:name, :brand_id, :category_id)
  end
end
