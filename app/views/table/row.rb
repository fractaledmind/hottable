module Views
  module Table
    class Row < Base
      def initialize(record, search:)
        @record = record
        @search = search
      end

      def template
        tr class: "divide-x divide-gray-200" do
          attributes.each do |attribute|
            render Column.new(@record, attribute:, search: @search)
          end
        end
      end

      private

      def attributes
        @search.field_attributes
      end
    end
  end
end
