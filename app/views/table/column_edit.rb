module Views
  class Table
    class ColumnEdit < Column

      private

      def body
        form action: book_path(@record), method: "patch", data: { action: "submit->column#update" } do
          if attribute_type != :enum
            input(
              value: value,
              data: { action: "blur->column#update" },
              name: "book[#{@attribute}]",
              class: "w-full px-2 py-2 text-sm",
              type: input_type(attribute_type)
            )
          else
            select(data: { action: "change->column#update" }, name: "book[#{@attribute}]") do
              option(value: "") { "" }

              Book.all.distinct.pluck(@attribute).sort.each do |code|
                option(value: code, selected: code == value) { code }
              end
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
