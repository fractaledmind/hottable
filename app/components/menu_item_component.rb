class MenuItemComponent < ApplicationComponent
  class Struct < ApplicationComponent::Struct
    def initialize()
    end

    def base
      {
        role: :menuitem,
        class: "group<menuitem> cursor-pointer text-gray-700 flex items-center px-4 py-2 space-x-2 hover:bg-gray-200",
        tabindex: -1,
      }
    end
  end

  def self.struct(*args, **kwargs)
    Struct.new(*args, **kwargs)
  end

  def initialize(as: :a, text: nil, icon: nil, url: nil, **attributes)
    @element = as
    @url = url
    @text = text
    @icon = icon
    @attributes = attributes
  end

  def template
    public_send(@element, **menuitem_attributes) do
      render Bootstrap::IconComponent.new(@icon) if @icon
      @text ? span { @text } : yield
    end
  end

  def struct
    self.class.struct()
  end

  private

  def menuitem_attributes
    attributify(struct.base, { href: @url }, @attributes)
  end
end
