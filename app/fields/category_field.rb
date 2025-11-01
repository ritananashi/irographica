require "administrate/field/select"

class CategoryField < Administrate::Field::Select
  def category_name
    Category.find(data).color
  end

  def html_controller
    "select"
  end
end
