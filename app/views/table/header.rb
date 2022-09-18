module Views
  class Table
    class Header < Base
      def initialize(attribute, search:)
        @attribute = attribute
        @search = search
      end

      def template
        th scope: :col,
           **classes("sticky top-0 bg-gray-50 border-b whitespace-nowrap px-2 py-3.5 text-left text-sm font-semibold text-gray-900 space-x-1",
             filtered?: "bg-green-300",
             sorted?: "bg-orange-300",
             primary_attribute?: "left-12 z-10"),
           style: "width: #{attribute_schema.fetch(:width, "initial")}" do
          render Bootstrap::Icon.new(attribute_icon), aria: { hidden: "true" }
          span Book.human_attribute_name(@attribute)
        end
      end

      private

      def filtered? = @search.condition_attributes.include? @attribute
      def sorted? = @search.sort_attributes.include? @attribute
      def primary_attribute? = Book.primary_attribute.to_s == @attribute.to_s
      def attribute_schema = Book.attribute_schema.fetch(@attribute.to_sym)

      def attribute_icon
        {
          string: "type",
          text: "text-paragraph",
          date: "calendar",
          numeric: "hash",
          enum: "usb-c-fill",
          datetime: "clock-fill"
        }.fetch(attribute_schema[:type])
      end
    end
  end
end
