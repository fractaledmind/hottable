module Views
  class Table
    class ColumnEdit < Column

      private

      def body
        form action: book_path(@record), method: "patch", data: { action: "submit->column#update" } do
          if attribute_type != :enum
            input(
              value: value,
              data: { action: "keypress->column#update blur->column#abort", column_target: "tooltip" },
              name: "book[#{@attribute}]",
              class: "w-full px-2 py-2 text-sm",
              type: input_type(attribute_type)
            )
          else
            select(data: { action: "change->column#update blur->column#abort" }, name: "book[#{@attribute}]") do
              option(value: "") { "" }

              Book.all.distinct.pluck(@attribute).sort.each do |code|
                option(value: code, selected: code == value) { code }
              end
            end
          end

          div data: { column_target: "tooltipTemplate" } do
            button class: "bg-red-400 hover:bg-red-500 py-1 px-2 mx-1 text-white rounded-full", data: { action: "click->column#abort" } do
              i class: "bi-x-circle-fill"
            end
            button class: "bg-green-400 hover:bg-green-500 py-1 px-2 mx-1 text-white rounded-full", data: { action: "click->column#update" } do
              i class: "bi-check-circle-fill"
            end
          end

          input type: "hidden", name: "book_attribute", value: @attribute
        end
      end

      def input_type(type)
        case type
        when :numeric
          "number"
        when :date
          "date"
        else
          "text"
        end
      end
    end
  end
end
