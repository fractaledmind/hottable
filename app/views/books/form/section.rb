module Views
  class Books::Form::Section < Base
    attr_reader :attributes

    def initialize(form, id:, **attributes)
      @form = form
      @id = id
      @attributes = attributes
    end

    def template(&)
      details class: "relative inline-block text-left z-20 group", id: @id, **attributes do
        content(&)
      end
    end

    def title(icon:, colored:, classes:, &block)
      summary class: "marker:hidden cursor-pointer" do
        div id: "#{@id}Button",
          aria: { expanded: "false", haspopup: "true" },
          **classes("inline-flex items-center justify-center gap-2 w-full rounded-md border-2 border-transparent bg-white px-4 py-2 font-medium text-gray-700 group-open:border-gray-200 hover:border-gray-300 focus:ring-offset-gray-100",
            -> { colored } => classes) do

          render Bootstrap::Icon.new(icon),
            class: "text-xl",
            aria: { hidden: "true" }

          span(&block)

          render Bootstrap::Icon.new("chevron-down",
            class: "text-gray-500 group-hover:text-gray-900",
            aria: { hidden: "true" })
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
  end
end
