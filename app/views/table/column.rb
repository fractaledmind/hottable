module Views
  class Table
    class Column < Base
      COLORS = [
        "bg-red-100 text-red-800",
        "bg-orange-100 text-orange-800",
        "bg-amber-100 text-amber-800",
        "bg-yellow-100 text-yellow-800",
        "bg-lime-100 text-lime-800",
        "bg-green-100 text-green-800",
        "bg-emerald-100 text-emerald-800",
        "bg-teal-100 text-teal-800",
        "bg-cyan-100 text-cyan-800",
        "bg-sky-100 text-sky-800",
        "bg-blue-100 text-blue-800",
        "bg-indigo-100 text-indigo-800",
        "bg-violet-100 text-violet-800",
        "bg-purple-100 text-purple-800",
        "bg-fuschia-100 text-fuschia-800",
        "bg-pink-100 text-pink-800",
        "bg-rose-100 text-rose-800",
      ]

      def initialize(record, attribute:, search:)
        @record = record
        @attribute = attribute
        @search = search
      end

      def template
        cell
      end

      private

      def cell
        if @attribute.to_s == Book.primary_attribute.to_s
          th scope: "row",
             **classes("text-sm font-medium text-gray-900 text-left sticky left-12 bg-white row-group-has-checked:bg-blue-100 row-group-has-checked:text-blue-900",
                 filtered?: "bg-green-200",
                 sorted?: "bg-orange-200",
                 grouped?: "bg-purple-200",
                 -> { attribute_type == :numeric } => "text-right",
                 -> { attribute_type == :enum } => "text-center"),
                id: dom_id(@record, "column_#{@attribute}"),
                data: {
                  id: @record.id,
                  controller: "column",
                  action: "dblclick->column#edit",
                  attribute: @attribute,
                  attribute_type: attribute_type,
                  edit_url: edit_book_path(@record),
                } do
            body
          end
        else
          td **classes("px-2 py-2 text-sm text-gray-500",
                filtered?: "bg-green-200 row-group-has-checked:bg-green-200/50",
                sorted?: "bg-orange-200 row-group-has-checked:bg-orange-200/50",
                grouped?: "bg-purple-200 row-group-has-checked:bg-purple-200/50",
                -> { attribute_type == :numeric } => "text-right",
                -> { attribute_type == :enum } => "text-center"),
                id: dom_id(@record, "column_#{@attribute}"),
                data: {
                  id: @record.id,
                  controller: "column",
                  action: "dblclick->column#edit",
                  attribute: @attribute,
                  attribute_type: attribute_type,
                  edit_url: edit_book_path(@record),
                } do
            body
          end
        end
      end

      def body
        return span(value, class: "px-2 py-2") if attribute_type != :enum

        color = tailwind_color_for_enum
        span @record.public_send(@attribute).to_s, **classes("inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-medium", tailwind_color_for_enum)
      end

      def filtered? = @search.condition_attributes.include? @attribute
      def sorted? = @search.sort_attributes.include? @attribute
      def grouped? = @search.batch_attribute == @attribute
      def attribute_type = Book.attribute_schema.fetch(@attribute.to_sym)

      def value = @record.public_send(@attribute).to_s

      def tailwind_color_for_enum
        index = (Digest::MD5.hexdigest(value).to_i(16) % COLORS.size) - 1
        COLORS[index]
      end
    end
  end
end
