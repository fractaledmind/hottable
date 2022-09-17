module Views
  module Form
    class Section < Base
      def initialize(form, id:)
        @form = form
      end

      def template(&)
        details class: "relative inline-block text-left z-20", id: @id do
          content(&)
        end
      end

      def title(icon:, &block)
        summary class: "marker:hidden cursor-pointer" do
          div id: "#{@id}Button",
            aria: { expanded: "true", haspopup: "true" },
            **classes("inline-flex items-center justify-center gap-2 w-full rounded-md border-2 border-transparent bg-white px-4 py-2 font-medium text-gray-700 shadow-sm hover:border-gray-300 focus:ring-offset-gray-100",
              hidden_fields?: "bg-blue-300 hover:border-blue-500") do

            i class: "text-xl bi-#{icon}", aria: { hidden: "true" }

            span(&block)

            i class: "bi-chevron-down text-gray-500 group-hover:text-gray-900", aria: { hidden: "true" }
          end
        end
      end

      def body(&block)
        div class: "absolute left-0 z-10 mt-1 min-w-72 origin-top-right divide-y divide-gray-100 rounded-md bg-white border-2 shadow-lg drop-shadow-lg focus:outline-none",
          role: "menu",
          aria: { orientation: "vertical", labelledby: "#{@id}Button" },
          tabindex: "-1",
          &block
      end

      private

      def hidden_fields? = @form.object.hidden_fields.any?
    end
  end
end
