module Ransack
  class Search
    def condition_attributes
      groupings_attr_names = groupings.flat_map { |g| g.conditions.flat_map { |c| c.attributes.map(&:attr_name) } }
      conditions_attr_names = conditions.flat_map { |c| c.attributes.map(&:attr_name) }
      (groupings_attr_names + conditions_attr_names).uniq
    end

    def sort_attributes
      sorts.map(&:attr_name).uniq
    end
  end
end
