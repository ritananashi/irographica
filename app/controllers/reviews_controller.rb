class ReviewsController < ApplicationController
  before_action :redirect_root, only: :new

  def index
    @reviews = Review.includes(:user, :product).all
  end

  def show
    @review = Review.find_by(params[:id])
  end

  def new
    @review = Review.new
  end

  def create
    @review = current_user.reviews.build(review_params)
    product_name = params[:review][:product_name]
    product = Product.find_by(name: product_name)
    @review.product_id = product.id if product

    if @review.save
      flash[:notice] = "レビューを投稿しました！"
      redirect_to reviews_path
    else
      flash.now[:alert] = "レビューの投稿に失敗しました"
      render new_review_path, status: :unprocessable_entity
    end
  end

  private

  def review_params
    params.require(:review).permit(:title, :body, :product_id, :paper, :pen)
  end
end
