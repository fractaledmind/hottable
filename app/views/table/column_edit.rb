module Views
  class Table
    class ColumnEdit < Column

      private

      def body
        form action: book_path(@record), method: "patch" do
          if attribute_type != :enum
            return input(
              value: value,
              data: { action: "change->column#update" },
              name: "book[#{@attribute}]",
              class: "w-full px-2 py-2 text-sm",
              type: input_type(attribute_type)
            )
          end

          select(data: { action: "change->column#update" }, name: "book[#{@attribute}]") do
            option(value: "") { "" }

            Book.all.distinct.pluck(@attribute).sort.each do |code|
              option(value: code, selected: code == value) { code }
            end
          end
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
