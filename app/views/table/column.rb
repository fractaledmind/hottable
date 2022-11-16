module Views
  class Table
    class Column < ApplicationComponent
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
          th(scope: "row",
             **classes("cursor-pointer text-sm font-medium text-gray-900 text-left sticky left-[calc(3rem+1px)] row-group-has-checked:text-blue-900",
                 filtered?: "bg-green-100 row-group-hover:bg-gray-green-100-mixed row-group-has-checked:bg-blue-green-100-mixed",
                 sorted?: "bg-orange-100 row-group-hover:bg-gray-orange-100-mixed row-group-has-checked:bg-blue-orange-100-mixed",
                 grouped?: "bg-purple-100 row-group-hover:bg-gray-purple-100-mixed row-group-has-checked:bg-blue-purple-100-mixed",
                 -> { !filtered? && !sorted? && !grouped? } => "bg-white",
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
                },
                style: "max-width: #{attribute_schema.fetch(:width, "initial")}") do
            body
          end
        else
          td(**classes("text-sm text-gray-500 cursor-pointer whitespace-nowrap text-ellipsis overflow-hidden",
                filtered?: "bg-green-100 row-group-hover:bg-gray-green-100-mixed row-group-has-checked:bg-green-100/50",
                sorted?: "bg-orange-100 row-group-hover:bg-gray-orange-100-mixed row-group-has-checked:bg-orange-100/50",
                grouped?: "bg-purple-100 row-group-hover:bg-gray-purple-100-mixed row-group-has-checked:bg-purple-100/50",
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
                },
                style: "max-width: #{attribute_schema.fetch(:width, "initial")}") do
            body
          end
        end
      end

      def body
        return div(class: "px-2 py-2 whitespace-nowrap text-ellipsis overflow-hidden") { number_with_precision(value, precision: Book.columns_hash[@attribute].sql_type_metadata.scale) } if attribute_type == :decimal
        return div(class: "px-2 py-2 whitespace-nowrap text-ellipsis overflow-hidden") { value } if attribute_type != :enum

        div(**classes("inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-medium", tailwind_color_for_enum)) { @record.public_send(@attribute).to_s }
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
