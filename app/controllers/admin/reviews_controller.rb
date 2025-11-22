module Admin
  class ReviewsController < Admin::ApplicationController
    include ProcessImages

    def create
      resource = new_resource(resource_params)
      authorize_resource(resource)
      resource.images.attach(process_images(images_params))

      if resource.save
        yield(resource) if block_given?
        redirect_to(
          after_resource_created_path(resource),
          notice: translate_with_resource("create.success")
        )
      else
        resource.images.purge
        render :new, locals: {
          page: Administrate::Page::Form.new(dashboard, resource)
        }, status: :unprocessable_entity
      end
    end
    # Overwrite any of the RESTful controller actions to implement custom behavior
    # For example, you may want to send an email after a foo is updated.
    #
    def update
      requested_resource.images.attach(process_images(images_params))
      super
    end

    def destroy
      if requested_resource.destroy
        requested_resource.images.purge_later if requested_resource.images.attached?
        flash[:notice] = translate_with_resource("destroy.success")
      else
        flash[:error] = requested_resource.errors.full_messages.join("<br/>")
      end
      redirect_to after_resource_destroyed_path(requested_resource), status: :see_other
    end

    # Override this method to specify custom lookup behavior.
    # This will be used to set the resource for the `show`, `edit`, and `update`
    # actions.
    #
    # def find_resource(param)
    #   Foo.find_by!(slug: param)
    # end

    # The result of this lookup will be available as `requested_resource`

    # Override this if you have certain roles that require a subset
    # this will be used to set the records shown on the `index` action.
    #
    # def scoped_resource
    #   if current_user.super_admin?
    #     resource_class
    #   else
    #     resource_class.with_less_stuff
    #   end
    # end

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

    def destroy_image
      image = requested_resource.images.find(params[:attachment_id])
      image.purge
      redirect_back(fallback_location: requested_resource)
    end

    private

    def images_params
      params.require(resource_class.model_name.param_key).permit(images: [])
    end

    def default_sorting_attribute
      :id
    end

    def default_sorting_direction
      :desc
    end
  end
end
