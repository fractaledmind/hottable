module Views
  class Table
    class Row < Base
      def initialize(record, search:, expanded: true)
        @record = record
        @search = search
        @expanded = expanded
      end

      def template
        tr **classes("divide-x divide-gray-200 row-group hover:bg-gray-100",
               -> { !@expanded } => "sr-only") do
          select_cell
          attributes.each do |attribute|
            render Column.new(@record, attribute:, search: @search)
          end
        end
      end

      private

      def attributes
        @search.field_attributes
      end
      
      def select_cell
        td class: "text-center relative" do
          input type: "checkbox",
                id: select_identifier,
                class: "hidden [.row-group:hover_&]:inline-block checked:inline-block peer rounded border-gray-300 text-indigo-600 focus:ring-indigo-500",
                aria: {
                  labelledby: "row_1 column_select"
                }
          span @record.id.to_s, class: "text-gray-600 inline-block [.row-group:hover_&]:hidden peer-checked:hidden"
          label for: select_identifier, class: "absolute inset-0"
        end
      end
      
      def select_identifier
        dom_id(@record, "select")
      end
    end
  end
end
