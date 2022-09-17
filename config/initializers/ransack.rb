module Ransack
  class Search
    def sort_attributes
      sorts.map(&:attr_name).uniq
    end
  end
end
