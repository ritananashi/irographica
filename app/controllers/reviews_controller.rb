class ReviewsController < ApplicationController
  include Sortable, ProcessImages

  before_action :redirect_root, only: %i[new edit]
  before_action :verify_access, only: :edit

  def index
    @pagy, @reviews = pagy(Review.includes(:images_attachments, user: :avatar_attachment, product: :brand).public_send(sort_parameter), limit: 10)
  end

  def new
    @review = Review.new
    @review.ink_recipes.build
  end

  def create
    @review = current_user.reviews.build(review_params)
    result = ActiveRecord::Base.transaction do
                set_product
                @review.images.attach(process_images(images_params)) if images_params.present?

                if @review.save
                  flash[:notice] = t("reviews.new.notice")
                  redirect_to root_path
                else
                  @review.images.purge if @review.images.attached?
                  raise ActiveRecord::Rollback
                end
              end
    unless result
      flash.now[:alert] = t("reviews.new.alert")
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @review = Review.find(params[:id])
    session[:referer] = request.referer
  end

  def edit
    @review = current_user.reviews.find(params[:id])
  end

  def update
    @review = current_user.reviews.find(params[:id])
    result = ActiveRecord::Base.transaction do
                set_product
                @review.images.attach(process_images(images_params)) if images_params.present?

                if @review.update(review_params)
                  flash[:notice] = t("reviews.edit.notice")
                  redirect_to review_path(@review)
                else
                  raise ActiveRecord::Rollback
                end
              end
    unless result
      flash.now[:alert] = t("reviews.edit.alert")
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    review = current_user.reviews.find(params[:id])
    ActiveRecord::Base.transaction do
      review.destroy!
      review.images.purge_later if review.images.attached?
    end
    flash[:notice] = t("reviews.delete.notice")
    if session[:referer].include?("users")
      redirect_to user_path(current_user), status: :see_other
    else
      redirect_to root_path, status: :see_other
    end
  end

  def search
    if params[:q].blank?
      @q = params[:q]
      @grouping_word = { "0"=>{ review_search_cont: @q } }
    else
      @q = params[:q].split(/[\s　]/)
      @grouping_word = @q.each_with_index.reduce({}) { |hash, (word, i)| hash.merge(i.to_s => { review_search_cont: word }) }
    end
    @c = params[:c]
    @grouping_word["Category_refine"] = { product_category_id_eq: @c }
    @pagy, @reviews = pagy(Review.ransack({ combinator: "and", groupings: @grouping_word }).
                           result(distinct: true).includes(:user, :images_attachments, product: :brand).public_send(sort_parameter), limit: 10)
  end

  private

  def review_params
    params.require(:review).permit(:title, :body, :product_id, :paper, :pen, ink_recipes_attributes: [:id, :name, :amount, :_destroy])
  end

  def images_params
    params.require(:review).permit(images: [])
  end

  def set_product
    product_name = params[:review][:product_name]
    product = Product.find_by(name: product_name)
    @review.product_id = product.id if product
  end

  def verify_access
    @review = Review.find(params[:id])
    redirect_to root_path, alert: "アクセスできません" unless @review.user.id == current_user.id
  end
end
