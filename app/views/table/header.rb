module Views
  class Table
    class Header < ApplicationComponent
      delegate :params, to: :@_view_context

      def initialize(attribute, search:)
        @attribute = attribute
        @search = search
      end

      def template
        th **header_attributes do
          render DetailsPopoverComponent.new(**popover_component_props) do |popover|
            popover.trigger **popover_trigger_attributes do
              render Bootstrap::IconComponent.new(attribute_icon)
              span Book.human_attribute_name(@attribute)
            end
            popover.portal **popover_portal_attributes do
              div class: "py-1" do
                render MenuItemComponent.new(**sort_asc_menu_item_props)
                render MenuItemComponent.new(**sort_desc_menu_item_props)
                render MenuItemComponent.new(**group_menu_item_props)
                render MenuItemComponent.new(**hide_field_menu_item_props)
              end
            end
          end
        end
      end

      private

      def header_attributes
        {
          scope: :col,
          style: "width: #{attribute_schema.fetch(:width, "initial")}",
          class: tokens(
            "sticky top-0 z-20 border-b whitespace-nowrap p-0 text-left text-sm font-semibold text-gray-900 space-x-1",
            conditionless?: "bg-gray-50",
            filtered?: "bg-#{SearchHelper.filter_color}-300",
            sorted?: "bg-#{SearchHelper.sort_color}-300",
            grouped?: "bg-#{SearchHelper.group_color}-300",
            primary_attribute?: "left-[calc(3rem+2px)] z-30"
          ),
        }
      end

      def popover_component_props
        {
          role: :menu,
          align: :start,
          class: "inline-block text-left z-30 w-full h-full",
          data: {
            details_set_target: "child",
            controller: "other",
          },
        }
      end

      def popover_trigger_attributes
        {
          class: "p-2 flex items-center gap-2",
        }
      end

      def popover_portal_attributes
        {
          class: "divide-y divide-gray-100 rounded-md bg-white border-2 shadow-lg overflow-auto max-h-[calc(100vh-250px)] focus:outline-none origin-top-right",
        }
      end

      def sort_asc_menu_item_props
        {
          url: search_and_sort_path(:asc),
          text: "Sort #{attribute_schema[:sort][:asc]}",
          icon: ["sort", attribute_schema[:sort][:icon], "down"].compact.join("-"),
        }
      end

      def sort_desc_menu_item_props
        {
          url: search_and_sort_path(:desc),
          text: "Sort #{attribute_schema[:sort][:desc]}",
          icon: ["sort", attribute_schema[:sort][:icon], "down-alt"].compact.join("-"),
        }
      end

      def group_menu_item_props
        {
          url: search_and_batch_path,
          text: "Group by this field",
          icon: "card-list",
        }
      end

      def hide_field_menu_item_props
        {
          url: search_and_fields_path,
          text: "Hide field",
          icon: "eye-slash",
        }
      end

      def filtered? = @search.condition_attributes.include? @attribute
      def sorted? = @search.sort_attributes.include? @attribute
      def grouped? = @search.batch_attribute == @attribute
      def conditionless? = !filtered? && !sorted? && !grouped?
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
