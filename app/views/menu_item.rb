module Views
  class MenuItem < Base
    def initialize(url, text, icon:, **attributes)
      @url = url
      @text = text
      @icon = icon
      @attributes = attributes
    end

    def template(&)
      a href: @url, class: "text-gray-700 group flex items-center px-4 py-2 space-x-2 hover:bg-gray-200", role: "menuitem", tabindex: "-1" do
        render Bootstrap::Icon.new(@icon), aria: { hidden: "true" }
        span @text
      end
    end
  end
end
