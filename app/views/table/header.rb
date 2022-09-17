module Views
  module Table
    class Header < Base
      def initialize(attribute, search:)
        @attribute = attribute
        @search = search
      end

      def template
        th Book.human_attribute_name(@attribute),
           scope: :col,
           **classes("sticky top-0 z-10 bg-opacity-75 backdrop-blur backdrop-filter whitespace-nowrap px-2 py-3.5 text-left text-sm font-semibold text-gray-900",
           filtered?: "bg-green-300",
           sorted?: "bg-orange-300")
      end

      private

      def filtered? = @search.condition_attributes.include? @attribute
      def sorted? = @search.sort_attributes.include? @attribute
    end
  end
end
