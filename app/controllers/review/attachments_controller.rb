class Review::AttachmentsController < ApplicationController
  def destroy
    image = ActiveStorage::Attachment.find(params[:id])
    image.purge
    redirect_to edit_review_path
  end
end
