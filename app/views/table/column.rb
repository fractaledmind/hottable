module Views
  module Table
    class Column < Base
      def initialize(record, attribute:, search:)
        @record = record
        @attribute = attribute
        @search = search
      end

      def template
        td @record.public_send(@attribute).to_s,
          **classes("px-2 py-2 text-sm text-gray-500",
            filtered?: "bg-green-200",
            sorted?: "bg-orange-200")
      end

      private

      def filtered? = @search.condition_attributes.include? @attribute
      def sorted? = @search.sort_attributes.include? @attribute
    end
  end
end
