module Views
  class Table
    class Column < Base
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
             **classes("px-2 py-2 text-sm font-medium text-gray-900 text-left sticky left-12 bg-white row-group-has-checked:bg-blue-100 row-group-has-checked:text-blue-900",
                 filtered?: "bg-green-200",
                 sorted?: "bg-orange-200",
                 grouped?: "bg-purple-200",
                 -> { attribute_type == :numeric} => "text-right",
                 -> { attribute_type == :enum} => "text-center") do
            body
          end
        else
          td **classes("px-2 py-2 text-sm text-gray-500 mix-blend-multiply",
                filtered?: "bg-green-200",
                sorted?: "bg-orange-200",
                grouped?: "bg-purple-200",
                -> { attribute_type == :numeric} => "text-right",
                -> { attribute_type == :enum} => "text-center") do
            body
          end
        end
      end

      def body
        return @record.public_send(@attribute).to_s if attribute_type != :enum

        color = tailwind_color_for_enum
        span @record.public_send(@attribute).to_s, **classes("inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-medium", tailwind_color_for_enum)
      end

      def filtered? = @search.condition_attributes.include? @attribute
      def sorted? = @search.sort_attributes.include? @attribute
      def grouped? = @search.batch_attribute == @attribute
      def attribute_type = Book.attribute_schema.fetch(@attribute.to_sym)

      def tailwind_color_for_enum
        colors = %i[red sky lime yellow violet orange blue emerald amber purple cyan green fuschia teal rose indigo pink]
        set = @record.class.select(@attribute).distinct.order(@attribute => :desc).pluck(@attribute)
        number = set.index(@record.public_send(@attribute).to_s)
        index = fit_to_minmax(number, max: colors.length)

        {
          red: "bg-red-100 text-red-800",
          orange: "bg-orange-100 text-orange-800",
          amber: "bg-amber-100 text-amber-800",
          yellow: "bg-yellow-100 text-yellow-800",
          lime: "bg-lime-100 text-lime-800",
          green: "bg-green-100 text-green-800",
          emerald: "bg-emerald-100 text-emerald-800",
          teal: "bg-teal-100 text-teal-800",
          cyan: "bg-cyan-100 text-cyan-800",
          sky: "bg-sky-100 text-sky-800",
          blue: "bg-blue-100 text-blue-800",
          indigo: "bg-indigo-100 text-indigo-800",
          violet: "bg-violet-100 text-violet-800",
          purple: "bg-purple-100 text-purple-800",
          fuschia: "bg-fuschia-100 text-fuschia-800",
          pink: "bg-pink-100 text-pink-800",
          rose: "bg-rose-100 text-rose-800",
        }.fetch(colors[index])

      end

      def fit_to_minmax(number, max:, min: 1)
        max_diff = max * number.div(max)
        fitted = number - max_diff
      
        return fitted if fitted >= min
      
        fit_to_minmax(fitted + 1, max: max, min: min)
      end
    end
  end
end
