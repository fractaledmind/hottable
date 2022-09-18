module Views
  class Table
    class ColumnSummary < Base
      def initialize(total, attribute:, calculation: nil)
        @total = total || nil
        @attribute = attribute
        @calculation = calculation
      end

      def template
        td id: [@attribute, "summary"].join("_") do
          form action: summarize_books_path, method: "get", accept_charset: "UTF-8", class: "text-right space-y-1 px-2", data: { controller: "element"} do
            div class: "whitespace-nowrap" do
              input type: "hidden", name: "attribute", value: @attribute
              select name: "calculation", id: "calculation", dir: "rtl", class: "bg-transparent border-transparent rounded text-gray-600 hover:bg-gray-300", data: { action: "change->element#click" }, autocomplete: "off" do
                option "None", value: "", selected: (@calculation == "")
                option "Empty", value: "nil", selected: (@calculation == "nil")
                option "Filled", value: "not_nil", selected: (@calculation == "not_nil")
                option "Unique", value: "unique", selected: (@calculation == "unique")
                option "Min", value: "min", selected: (@calculation == "min") if [:numeric, :decimal].include?(attribute_type)
                option "Max", value: "max", selected: (@calculation == "max") if [:numeric, :decimal].include?(attribute_type)
                option "Average", value: "avg", selected: (@calculation == "avg") if [:numeric, :decimal].include?(attribute_type)
                option "Sum", value: "sum", selected: (@calculation == "sum") if [:numeric, :decimal].include?(attribute_type)
                option "Earliest Date", value: "earliest", selected: (@calculation == "earliest") if [:date, :datetime].include?(attribute_type)
                option "Latest Date", value: "latest", selected: (@calculation == "latest") if [:date, :datetime].include?(attribute_type)
              end

              output @total.to_s, class: "inline-block text-left ml-2"
            end
            noscript do
              div class: "flex justify-end gap-1" do
                input type: "reset", value: "Cancel", class: "cursor-pointer inline-flex items-center rounded-md border border-transparent bg-gray-200 px-2 py-1 text-base font-medium text-gray-900 hover:bg-gray-300"
          
                input type: "submit", value: "Apply", class: "inline-flex items-center rounded-md border border-transparent bg-blue-500 px-2 py-1 text-base font-medium text-white shadow-sm hover:bg-blue-400"
              end
            end
            input type: "submit", name: "pagy", hidden: true, data: { 'element-target': "click" }
            authenticity_token_input
          end
        end
      end
      
      private

      def attribute_schema = Book.attribute_schema.fetch(@attribute.to_sym)
      def attribute_type = attribute_schema[:type]
      
      def authenticity_token_input
        input type: "hidden",
              name: "authenticity_token",
              autocomplete: "off",
              value: @_view_context.form_authenticity_token
      end
    end
  end
end
