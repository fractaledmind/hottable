module Views
  class Table
    class ColumnEdit < Column

      private

      def body
        form action: book_path(@record), method: "patch" do
          if attribute_type != :enum
            return input(value: value, data: { action: "change->column#click"}, name: "book[#{@attribute}]", class: "w-full")
          end

          span @record.public_send(@attribute).to_s, **classes("inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-medium", tailwind_color_for_enum)
        end
      end
    end
  end
end
