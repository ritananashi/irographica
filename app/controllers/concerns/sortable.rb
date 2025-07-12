module Sortable
  extend ActiveSupport::Concern

  def sort_parameter
    case
    when params[:latest]
      :latest
    when params[:old]
      :old
    when params[:likes]
      :likes
    else
      :latest
    end
  end
end
