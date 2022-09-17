module Views
  class Table
    class Head < Base
      def initialize(search:)
        @search = search
      end

      def template
        thead class: "bg-gray-50" do
          tr class: "divide-x divide-gray-200" do
            select_cell
            attributes.each do |attribute|
              render Header.new(attribute, search: @search)
            end
          end
        end
      end

      private

      def attributes = @search.field_attributes

      def select_cell
        th scope: 'col',
           class: 'w-12 text-center sticky top-0 z-10 bg-opacity-75 backdrop-blur backdrop-filter whitespace-nowrap px-2 py-3.5 text-left text-sm font-semibold text-gray-900',
           id: 'column_select' do
          label for: "selectAll", class: "sr-only"
          input type: "checkbox",
                class: "rounded border-gray-300 text-indigo-600 focus:ring-indigo-500"
        end
      end
    end
  end
end
