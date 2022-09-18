module Views
  class Books::Form::Section < Base
    attr_reader :attributes

    def initialize(id:, type: :button, pinned: :right, **attributes)
      @id = id
      @type = type
      @pinned = pinned
      @attributes = attributes
    end

    def template(&)
      props = attributes.deep_merge(data: { controller: "details-dropdown" }) do |key, oldval, newval|
        if ["class", "controller"].include?(key.to_s)
          [newval, oldval].join(' ')
        else
          newval
        end
      end
      details **classes("relative inline-block text-left z-30 group", -> { @type == :header } => "w-full h-full"), id: @id, **props do
        content(&)
      end
    end

    def title(icon:, colored: false, classes: {}, &block)
      summary **classes("marker:hidden cursor-pointer flex items-center",
                -> { @type == :header } => "h-full p-2 hover:bg-gray-300") do
        div id: "#{@id}Button",
          aria: { expanded: "false", haspopup: "true" },
          data: { action: "click@window->details-dropdown#hide touchend@window->details-dropdown#hide", 'details-dropdown-target': "button" },
          **classes(
            -> { @type == :button } => "inline-flex items-center justify-center gap-2 w-full rounded-md border-2 border-transparent bg-white px-4 py-2 font-medium text-gray-700 focus:ring-offset-gray-100",
            -> { @type == :header } => "flex items-center justify-between gap-2",
            -> { colored } => classes,
            -> { !colored } => "group-open:border-gray-200 hover:border-gray-300") do

          render Bootstrap::Icon.new(icon),
            class: "text-xl",
            aria: { hidden: "true" }

          span class: "whitespace-nowrap", &block

          render Bootstrap::Icon.new("chevron-down",
            class: "text-gray-500 group-hover:text-gray-900",
            aria: { hidden: "true" })
        end
      end
    end

    def body(&block)
      div **classes("absolute mt-1 divide-y divide-gray-100 rounded-md bg-white border-2 shadow-lg overflow-auto max-h-[calc(100vh-250px)] focus:outline-none",
            -> { @type == :button } => "min-w-72",
            -> { @pinned == :right } => "origin-top-left right-0",
            -> { @pinned == :left } => "origin-top-right left-0"),
        role: "menu",
        aria: { orientation: "vertical", labelledby: "#{@id}Button" },
        tabindex: "-1",
        &block
    end
  end
end
