class ProductsController < ApplicationController
  def index
    if params[:q].blank?
      @q = params[:q]
      @grouping_word = { "0"=>{ name_or_brand_name_cont: @q } }
    else
      @q = params[:q].split(/[\s　]/)
      @grouping_word = @q.each_with_index.reduce({}) { |hash, (word, i)| hash.merge(i.to_s => { name_or_brand_name_cont: word }) }
    end
    @pagy, @products = pagy(Product.ransack({ combinator: "and", groupings: @grouping_word }).
                            result(distinct: true).includes(:brand).order(created_at: "DESC"), limit: 10)
  end

  def show
    @product = Product.find(params[:id])
    @pagy, @reviews = pagy(@product.reviews, limit: 10)
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
      @grouping_word = { "0"=>{ name_or_brand_name_cont: @q } }
    else
      @q = params[:q].split(/[\s　]/)
      @grouping_word = @q.each_with_index.reduce({}) { |hash, (word, i)| hash.merge(i.to_s => { name_or_brand_name_cont: word }) }
    end
    @c = params[:c]
    @grouping_word["Category_refine"] = { category_id_eq: @c }
    @pagy, @products = pagy(Product.ransack({ combinator: "and", groupings: @grouping_word }).
                            result(distinct: true).includes(:brand).order(created_at: "DESC"), limit: 9)
  end

  def autocomplete
    case
    # 検索フォーム用
    when params[:q]
      @q = params[:q]
      @products = Product.ransack(name_cont: @q).result(distinct: true)
      @brands = Brand.ransack(name_cont: @q).result(distinct: true)
    # インクのみ検索（投稿フォーム入力欄＆インク登録欄）
    when params[:product_name]
      @q = params[:product_name]
      @products = Product.ransack(name_cont: @q).result(distinct: true)
    # メーカー名のみ検索（インク登録欄）
    when params[:brand_name]
      @q = params[:brand_name]
      @brands = Brand.ransack(name_cont: @q).result(distinct: true)
    end
    render layout: "main_only"
  end

  private

  def product_params
    params.require(:product).permit(:name, :brand_id, :category_id)
  end
end
