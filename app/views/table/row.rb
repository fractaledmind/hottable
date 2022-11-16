module Views
  class Table
    class Row < ApplicationComponent
      def initialize(record, search:, expanded: true, inline_edit: false)
        @record = record
        @search = search
        @expanded = expanded
        @inline_edit = inline_edit
      end

      def template
        tr(**classes("row-group hover:bg-gray-100 has-checked:bg-blue-100",
               -> { !@expanded } => "sr-only"), id: dom_id(@record, :row), data_groupable_target: "row") do
          select_cell
          attributes.each do |attribute|
            render column_class.new(@record, attribute:, search: @search)
          end
        end
      end

      private

      def column_class
        @inline_edit ? ColumnEdit : Column
      end

      def attributes
        @search.field_attributes
      end

      def select_cell
        td(class: "text-center relative sticky left-px bg-white w-12 text-sm") do
          input(type: "checkbox",
                id: select_identifier,
                class: "hidden [.row-group:hover_&]:inline-block checked:inline-block peer rounded border-gray-300 text-blue-600 focus:ring-blue-500",
                name: "select[#{@record.id}]",
                form: "searchForm",
                aria: {
                  labelledby: "row_1 column_select"
                },
                data: {
                  checkbox_set_target: "child",
                  row_checkbox: true
                })
          span(class: "ml-1 text-gray-600 inline-block [.row-group:hover_&]:hidden peer-checked:hidden") { @record.id.to_s }
          label for: select_identifier, class: "absolute inset-0"
          div class: "absolute inset-y-0 left-0 w-1 bg-blue-600 hidden peer-checked:block"
        end
      end

      def select_identifier
        dom_id(@record, "select")
      end
    end
  end
end
