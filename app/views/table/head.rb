module Views
  class Table
    class Head < ApplicationComponent
      def initialize(search:)
        @search = search
      end

      def template
        thead class: "bg-gray-50" do
          tr class: "h-12" do
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
           class: 'w-12 relative text-center sticky top-0 left-px z-10 bg-gray-50 whitespace-nowrap px-2 py-3.5 text-sm font-semibold text-gray-900',
           id: 'column_select' do
          label for: "selectAll", class: "absolute inset-0"
          input type: "checkbox",
                id: "selectAll",
                class: "rounded border-gray-300 text-blue-600 focus:ring-blue-500",
                name: "selectAll",
                form: "searchForm",
                data: {
                  action: "checkbox-set#matchAll",
                  checkbox_set_target: "parent"
                }
        end
      end
    end
  end
end
