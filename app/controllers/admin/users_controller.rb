module Admin
  class UsersController < Admin::ApplicationController
    def create
      resource = new_resource(resource_params)
      authorize_resource(resource)
      resource.password = params[:user][:password]

      if params[:user][:avatar].present?
        process_and_resize_avatar
        resource.avatar.attach(io: @process_avatar, filename: "#{@filename_base}.webp", content_type: "image/webp")
      end

      if resource.save
        yield(resource) if block_given?
        redirect_to(
          after_resource_created_path(resource),
          notice: translate_with_resource("create.success")
        )
      else
        render :new, locals: {
          page: Administrate::Page::Form.new(dashboard, resource)
        }, status: :unprocessable_entity
      end
    end
    # Overwrite any of the RESTful controller actions to implement custom behavior
    # For example, you may want to send an email after a foo is updated.
    #
    def update
      super
      if params[:user][:avatar].present?
        process_and_resize_avatar
        requested_resource.avatar.attach(io: @process_avatar, filename: "#{@filename_base}.webp", content_type: "image/webp")
      end
    end

    # Override this method to specify custom lookup behavior.
    # This will be used to set the resource for the `show`, `edit`, and `update`
    # actions.
    #
    def find_resource(param)
      User.find_by!(account: param)
    end

    # The result of this lookup will be available as `requested_resource`

    # Override this if you have certain roles that require a subset
    # this will be used to set the records shown on the `index` action.
    #
    def scoped_resource
      resource_class.with_attached_avatar
    end

    # For illustrative purposes only.
    #
    # **SECURITY NOTICE**: first verify whether current user is authorized to perform the action.
    def destroy_avatar
      avatar = requested_resource.avatar
      avatar.purge
      redirect_back(fallback_location: requested_resource)
    end

    # Override `resource_params` if you want to transform the submitted
    # data before it's persisted. For example, the following would turn all
    # empty values into nil values. It uses other APIs such as `resource_class`
    # and `dashboard`:
    #
    # def resource_params
    #   params.require(resource_class.model_name.param_key).
    #     permit(dashboard.permitted_attributes(action_name)).
    #     transform_values { |value| value == "" ? nil : value }
    # end

    # See https://administrate-demo.herokuapp.com/customizing_controller_actions
    # for more information

    private

    def process_and_resize_avatar
      @process_avatar = ImageProcessing::MiniMagick.source(params[:user][:avatar].tempfile).resize_to_fit(300, 300).convert("webp").call
      @filename_base = File.basename(params[:user][:avatar].original_filename, ".*")
    end
  end
end
