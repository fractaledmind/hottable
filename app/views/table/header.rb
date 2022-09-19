module Views
  class Table
    class Header < Base
      include Ransack::Helpers::FormHelper

      delegate :params, to: :@_view_context

      def initialize(attribute, search:)
        @attribute = attribute
        @search = search
      end

      def template
        th scope: :col,
           **classes("sticky top-0 z-20 border-b whitespace-nowrap p-0 text-left text-sm font-semibold text-gray-900 space-x-1",
             filtered?: "bg-green-300",
             sorted?: "bg-orange-300",
             grouped?: "bg-purple-300",
             -> { !filtered? && !sorted? && !grouped? } => "bg-gray-50",
             primary_attribute?: "left-12 z-30"),
           style: "width: #{attribute_schema.fetch(:width, "initial")}" do
          render Views::Books::Form::Section.new(id: "", type: :header, pinned: :left, data: { 'details-set-target': "child" }) do |section|
            section.title icon: attribute_icon do
              span Book.human_attribute_name(@attribute)
            end
            section.body do
              div class: "py-1", role: "none" do
                render Views::MenuItem.new(
                  search_and_sort_path(:asc),
                  "Sort #{attribute_schema[:sort][:asc]}",
                  icon: ["sort", attribute_schema[:sort][:icon], "down"].compact.join("-"))
                render Views::MenuItem.new(
                  search_and_sort_path(:desc),
                  "Sort #{attribute_schema[:sort][:desc]}",
                  icon: ["sort", attribute_schema[:sort][:icon], "down-alt"].compact.join("-"))
                render Views::MenuItem.new(search_and_batch_path, "Group by this field", icon: "card-list")
                render Views::MenuItem.new(search_and_fields_path, "Hide field", icon: "card-list")
              end
            end
          end
        end
      end

      private

      def filtered? = @search.condition_attributes.include? @attribute
      def sorted? = @search.sort_attributes.include? @attribute
      def grouped? = @search.batch_attribute == @attribute
      def primary_attribute? = Book.primary_attribute.to_s == @attribute.to_s
      def attribute_schema = Book.attribute_schema.fetch(@attribute.to_sym)
      def search_params = params.to_unsafe_hash[@search.context.search_key].presence || {}

      def attribute_icon
        {
          string: "type",
          text: "text-paragraph",
          date: "calendar",
          numeric: "hash",
          decimal: "hash",
          enum: "usb-c-fill",
          datetime: "clock-fill"
        }.fetch(attribute_schema[:type])
      end

      def search_and_sort_path(dir)
        search_and_sort_params = search_params.merge(s: [@attribute, dir].join(" "))
        url_params = params.to_unsafe_hash.merge(@search.context.search_key => search_and_sort_params)
        url_for({only_path: true}.merge(url_params))
      end

      def search_and_batch_path
        search_and_batch_params = search_params.merge(b: {name: @attribute, dir: :asc, expanded: true})
        url_params = params.to_unsafe_hash.merge(@search.context.search_key => search_and_batch_params)
        url_for({only_path: true}.merge(url_params))
      end

      def search_and_fields_path
        search_and_fields_params = search_params.merge(f: @search.field_attributes - [@attribute])
        url_params = params.to_unsafe_hash.merge(@search.context.search_key => search_and_fields_params)
        url_for({only_path: true}.merge(url_params))
      end
    end
  end
end
