module Views
  class Table
    class Column < Base
      COLORS = [
        "bg-red-300 text-red-800",
        "bg-orange-300 text-orange-800",
        "bg-amber-300 text-amber-800",
        "bg-yellow-300 text-yellow-800",
        "bg-lime-300 text-lime-800",
        "bg-green-300 text-green-800",
        "bg-emerald-300 text-emerald-800",
        "bg-teal-300 text-teal-800",
        "bg-cyan-300 text-cyan-800",
        "bg-sky-300 text-sky-800",
        "bg-blue-300 text-blue-800",
        "bg-indigo-300 text-indigo-800",
        "bg-violet-300 text-violet-800",
        "bg-purple-300 text-purple-800",
        "bg-fuschia-300 text-fuschia-800",
        "bg-pink-300 text-pink-800",
        "bg-rose-300 text-rose-800",
      ]
      include ActionView::Helpers::NumberHelper

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
             **classes("cursor-pointer text-sm font-medium text-gray-900 text-left sticky left-12 row-group-has-checked:bg-blue-100 row-group-has-checked:text-blue-900",
                 filtered?: "bg-green-100/50",
                 sorted?: "bg-orange-100/50",
                 grouped?: "bg-purple-100/50",
                 -> { !filtered? && !sorted? && !grouped? } => "bg-white/50",
                 -> { [:numeric, :decimal].include? attribute_type } => "text-right",
                 -> { attribute_type == :enum } => "text-center"),
                id: dom_id(@record, "column_#{@attribute}"),
                data: {
                  id: @record.id,
                  controller: "column",
                  action: self.class == Views::Table::Column ? "dblclick->column#edit" : "",
                  attribute: @attribute,
                  attribute_type: attribute_type,
                  edit_url: edit_book_path(@record),
                } do
            body
          end
        else
          td **classes("text-sm text-gray-500 cursor-pointer",
                filtered?: "bg-green-100 row-group-has-checked:bg-green-100/50",
                sorted?: "bg-orange-100 row-group-has-checked:bg-orange-100/50",
                grouped?: "bg-purple-100 row-group-has-checked:bg-purple-100/50",
                -> { [:numeric, :decimal].include? attribute_type } => "text-right",
                -> { attribute_type == :enum } => "text-center"),
                id: dom_id(@record, "column_#{@attribute}"),
                data: {
                  id: @record.id,
                  controller: "column",
                  action: self.class == Views::Table::Column ? "dblclick->column#edit" : "",
                  attribute: @attribute,
                  attribute_type: attribute_type,
                  edit_url: edit_book_path(@record),
                } do
            body
          end
        end
      end

      def body
        return div(number_with_precision(value, precision: Book.columns_hash[@attribute].sql_type_metadata.scale), class: "px-2 py-2") if attribute_type == :decimal
        return div(value, class: "px-2 py-2") if attribute_type != :enum

        color = tailwind_color_for_enum
        div @record.public_send(@attribute).to_s, **classes("inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-medium", tailwind_color_for_enum)
      end

      def filtered? = @search.condition_attributes.include? @attribute
      def sorted? = @search.sort_attributes.include? @attribute
      def grouped? = @search.batch_attribute == @attribute
      def attribute_schema = Book.attribute_schema.fetch(@attribute.to_sym)
      def attribute_type = attribute_schema[:type]

      def value = @record.public_send(@attribute).to_s

      def tailwind_color_for_enum
        index = (Digest::MD5.hexdigest(value).to_i(16) % COLORS.size) - 1
        COLORS[index]
      end
    end
  end
end
