module Views
  class Books::Form::Section < ApplicationComponent
    attr_reader :attributes

    def initialize(id:, type: :button, pinned: :right, **attributes)
      @id = id
      @type = type
      @pinned = pinned
      @attributes = attributes
    end

    def template(&)
      render DetailsPopoverComponent.new(align: :end, class: "inline-block text-left z-30", id: @id) do |popover|
        @popover = popover

        content(&)
      end
    end

    def title(icon:, colored: false, classes: {}, &block)
      @popover.trigger **classes("inline-flex items-center justify-center gap-2 w-full rounded-md border-2 border-transparent bg-white px-4 py-2 font-medium text-gray-700 focus:ring-offset-gray-100", -> { colored } => classes, -> { !colored } => "group-open:border-gray-200 hover:border-gray-300") do
        render Bootstrap::IconComponent.new(icon, class: "text-xl")
      
        span class: "whitespace-nowrap", &block
      end
    end

    def body(&block)
      @popover.portal **classes("mt-1 divide-y divide-gray-100 rounded-md bg-white border-2 shadow-lg overflow-auto max-h-[calc(100vh-250px)] focus:outline-none", -> { @type == :button } => "min-w-72"), &block
    end
  end
end
