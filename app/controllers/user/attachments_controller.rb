class User::AttachmentsController < ApplicationController
  def destroy
    avatar = ActiveStorage::Attachment.find(params[:id])
    avatar.purge
    redirect_to edit_user_registration_path
  end
end
