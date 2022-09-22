class MenuItemComponent < ApplicationComponent
  def self.attributes
    {
      role: :menuitem,
      class: "group<menuitem> cursor-pointer text-gray-700 flex items-center px-4 py-2 space-x-2 hover:bg-gray-200",
      tabindex: -1,
    }
  end

  def initialize(as: :a, text: nil, icon: nil, url: nil, **attributes)
    @element = as
    @url = url
    @text = text
    @icon = icon
    @attributes = attributes
  end

  def template(&)
    public_send(@element, **menuitem_attributes) do
      render Bootstrap::IconComponent.new(@icon) if @icon
      @text ? span(@text) : content(&)
    end
  end

  private

  def menuitem_attributes
    default_attributes = merge_attributes(self.class.attributes, { href: @url })

    merge_attributes(default_attributes, @attributes)
  end
end
