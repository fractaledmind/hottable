module Views
  class Table
    class Footer < Base
      include Pagy::Frontend

      delegate :request, to: :@_view_context
      delegate :params, to: :@_view_context

      def initialize(search, pagy:)
        @search = search
        @pagy = pagy
      end

      def template
        tfoot class: "sticky bottom-0 bg-gray-100" do
          tr do
            td colspan: attributes.size + 1 do
              div class: "flex items-center justify-between py-2 px-4" do
                page_items_form
                raw pagy_nav(@pagy)
                raw pagy_info(@pagy)
              end
            end
          end
        end
      end

      private

      def attributes = @search.field_attributes

      def page_items_form
        form action: search_books_path, method: "post", accept_charset: "UTF-8" do
          authenticity_token_input
          select name: "page_items", id: "page_items" do
            [10, 20, 50, 100].map do |item|
              option item.to_s, value: item.to_s, selected: Array(params[:page_items]).include?(item.to_s)
            end
          end
          input type: "submit",
                name: "pagy",
                value: "Update",
                class: "cursor-pointer inline-flex items-center justify-center rounded-md border border-transparent bg-indigo-600 px-4 py-2 text-sm font-medium text-white shadow-sm hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2 sm:w-auto",
                data_disable_with: "Update"
        end
      end

      def authenticity_token_input
        input type: "hidden",
              name: "authenticity_token",
              autocomplete: "off",
              value: @_view_context.form_authenticity_token
      end
    end
  end
end
