module Views
  class Books::TabPopover < ApplicationComponent
    def initialize(title, icon: nil, active: false)
      @title = title
      @icon = icon
      @active = active
    end

    def template(&)
      render PopoverComponent.new(role: :menu, align: :start, **details_attributes) do |popover|
        @popover = popover

        @popover.trigger class: "px-4 py-2 flex items-center gap-1" do
          render Bootstrap::IconComponent.new(@icon) if @icon
          text @title
        end

        yield_content(&)
      end
    end

    def body(&)
      @popover.portal(**popover_portal_attributes, &)
    end

    private

    def details_attributes
      {
        class: tokens(
          "z-40 border-transparent group rounded-t rounded-b-none inline-flex items-center border-b font-medium",
          inactive?: "text-white hover:bg-violet-900 open:bg-violet-900 hover:border-white",
          active?: "bg-white text-gray-800 hover:bg-gray-100"
        ),
        data: {
          details_set_target: "child"
        }
      }
    end

    def popover_portal_attributes
      {
        class: "divide-y divide-gray-100 rounded-md bg-white border-2 shadow-lg drop-shadow-lg focus:outline-none w-64 group",
        aria: { orientation: "vertical" },
      }
    end

    def current_page? = params.dig(:views, :name) == @view.name
    def active? = !!@active
    def inactive? = !@active
  end
end
