class MenuComponent < ApplicationComponent
  class Struct < ApplicationComponent::Struct
    def initialize()
    end

    def root
      {
        role: :menu,
        class: tokens(
          "z-40 group<menu>",
        ),
      }
    end

    def trigger
      {}
    end

    def portal
      {
        class: "divide-y divide-gray-100 rounded-md bg-white border-2 shadow-lg drop-shadow-lg focus:outline-none w-64 group",
        aria: { orientation: "vertical" },
      }
    end
  end

  def self.struct(*args, **kwargs)
    Struct.new(*args, **kwargs)
  end

  def initialize(icon: nil, side: :bottom, align: :center, **attributes)
    @icon = icon
    @side = side
    @align = align
    @attributes = attributes
  end

  def template
    render PopoverComponent.new(role: :menu, side: @side, align: @align, **attributify(struct.root, @attributes)) do |popover|
      @popover = popover

      yield
    end
  end

  def trigger(**attributes, &)
    @popover.trigger(**attributify(struct.trigger, button.base, attributes), &)
  end

  def portal(**attributes, &)
    @popover.portal(**attributify(struct.portal, attributes), &)
  end

  def group(&)
    div(class: "py-1", &)
  end

  def struct
    self.class.struct()
  end

  private

  def button
    ButtonComponent.struct
  end
end
