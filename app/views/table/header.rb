module Views
  class Table
    class Header < Base
      def initialize(attribute, search:)
        @attribute = attribute
        @search = search
      end

      def template
        th scope: :col,
           **classes("sticky top-0 z-10 bg-gray-50 border-b whitespace-nowrap px-2 py-3.5 text-left text-sm font-semibold text-gray-900 space-x-1",
           filtered?: "bg-green-300",
           sorted?: "bg-orange-300") do
          render Bootstrap::Icon.new(attribute_icon), aria: { hidden: "true" }
          span Book.human_attribute_name(@attribute)
        end
      end

      private

      def filtered? = @search.condition_attributes.include? @attribute
      def sorted? = @search.sort_attributes.include? @attribute
      
      def attribute_icon
        type = Book.attribute_schema.fetch(@attribute.to_sym)
        {
          string: "type",
          text: "text-paragraph",
          date: "calendar",
          numeric: "hash",
          enum: "circle-fill",
          datetime: "clock-fill"
        }.fetch(type)
      end
    end
  end
end
