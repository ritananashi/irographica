require "administrate/base_dashboard"

class UserDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    account: Field::String,
    avatar: Field::ActiveStorage.with_options(
      destroy_url: proc do |namespace, resource, attachment|
        [:avatar_admin_user, { id: resource.account, attachment_id: attachment.id }]
      end
    ),
    body: Field::String,
    bookmark_reviews: Field::HasMany,
    bookmarks: Field::HasMany,
    email: Field::String,
    encrypted_password: Field::String,
    instagram_account: Field::String,
    likes: Field::HasMany,
    name: Field::String,
    remember_created_at: Field::DateTime,
    reset_password_sent_at: Field::DateTime,
    reset_password_token: Field::String,
    reviews: Field::HasMany,
    x_account: Field::String,
    youtube_account: Field::String,
    admin: Field::Boolean,
    created_at: Field::DateTime,
    updated_at: Field::DateTime
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
    id
    account
    name
    avatar
    admin
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    id
    account
    name
    email
    admin
    avatar
    body
    instagram_account
    x_account
    youtube_account
    likes
    bookmark_reviews
    bookmarks
    remember_created_at
    reset_password_sent_at
    reset_password_token
    reviews
    created_at
    updated_at
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    account
    name
    email
    admin
    avatar
    body
    instagram_account
    x_account
    youtube_account
    reviews
    likes
    bookmark_reviews
    bookmarks
  ].freeze

  # COLLECTION_FILTERS
  # a hash that defines filters that can be used while searching via the search
  # field of the dashboard.
  #
  # For example to add an option to search for open resources by typing "open:"
  # in the search field:
  #
  #   COLLECTION_FILTERS = {
  #     open: ->(resources) { resources.where(open: true) }
  #   }.freeze
  COLLECTION_FILTERS = {}.freeze

  # Overwrite this method to customize how users are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(user)
    "#{user.name}"
  end
end
