class MenuItemComponent < ApplicationComponent
  def initialize(url:, text:, icon:, **attributes)
    @url = url
    @text = text
    @icon = icon
    @attributes = attributes
  end

  def template(&)
    a **merge_attributes(link_attributes, @attributes) do
      render Bootstrap::IconComponent.new(@icon)
      span @text
    end
  end
  
  private
  
  def link_attributes
    {
      href: @url,
      role: :menuitem,
      class: "text-gray-700 flex items-center px-4 py-2 space-x-2 hover:bg-gray-200",
      tabindex: -1,
    }
  end
end
