require "administrate/field/base"

class CategoryField < Administrate::Field::Select
  def category_name
    category_id = data
    Category.find(category_id).color
  end

  def html_controller
    "select"
  end
end
