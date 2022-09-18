module Views
  class Table
    class ColumnEdit < Column

      private

      def body
        form action: book_path(@record), method: "patch" do
          if attribute_type != :enum
            return input(
              value: value,
              data: { action: "change->column#click" },
              name: "book[#{@attribute}]",
              class: "w-full",
              type: input_type(attribute_type)
            )
          end

          select do
            option(value: "") { "" } if value.present?
            option(value: value, selected: true) { value }
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
