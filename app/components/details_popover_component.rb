class DetailsPopoverComponent < ApplicationComponent
  class InvalidSide < StandardError
    def initialize(side)
      super("`#{side.inspect}` must be one of `:top`, `:bottom`, `:left`, or `:right`")
    end
  end
  class InvalidAlign < StandardError
    def initialize(align)
      super("`#{align.inspect}` must be one of `:start`, `:center`, or `:end`")
    end
  end
  class InvalidRole < StandardError
    def initialize(role)
      super("`#{role.inspect}` must be one of `:menu`, `:listbox`, `:tree`, `:grid`, or `:dialog`")
    end
  end

  def initialize(role: :dialog, side: :bottom, align: :center, **attributes)
    @role = role
    raise InvalidRole.new(role) unless [:menu, :listbox, :tree, :grid, :dialog].include? role
    @side = side
    raise InvalidSide.new(side) unless [:top, :bottom, :left, :right].include? side
    @align = align
    raise InvalidAlign.new(align) unless [:start, :center, :end].include? align
    @attributes = attributes
    @popover_id = "details-popover-#{@role}-#{object_id}"
  end

  def template(&)
    details **merge_attributes(root_attributes, @attributes) do
      content(&)
    end
  end

  def trigger(icon: true, **attributes, &block)
    summary **trigger_attributes do
      div **merge_attributes({class: "h-full"}, attributes) do
        content(&block)

        render trigger_icon(icon) if icon
      end
    end
  end

  def portal(**attributes, &block)
    div **merge_attributes(portal_attributes, attributes), &block
  end

  private

  def root_attributes
    {
      class: "relative group",
      data: { controller: "details-popover" }
    }
  end

  def trigger_attributes
    {
      class: tokens("marker:hidden cursor-pointer h-full"),
      aria: {
        expanded: "false",
        haspopup: @role,
        controls: @popover_id,
      },
      data: {
        action: "click@window->details-popover#hide touchend@window->details-popover#hide",
        details_dropdown_target: "button",
      },
    }
  end

  def portal_attributes
    {
      id: @popover_id,
      role: @role,
      tabindex: -1,
      data: {
        side: @side,
        align: @align,
      },
      class: tokens(
        "absolute z-40",
        side_top?: "bottom-full mb-1",
        side_bottom?: "top-full mt-1",
        vertical_start?: "left-0",
        vertical_center?: "left-1/2 -translate-x-1/2",
        vertical_end?: "right-0",
        side_left?: "right-full mr-1",
        side_right?: "left-full ml-1",
        horizontal_start?: "top-0",
        horizontal_center?: "top-1/2 -translate-y-1/2",
        horizontal_end?: "bottom-0 ",
      ),
    }
  end

  def trigger_icon(passed_icon = nil)
    icon_name = passed_icon == true ? "chevron-#{trigger_icon_direction}" : passed_icon

    Bootstrap::IconComponent.new(
      icon_name,
      class: "text-gray-500 group-hover:text-gray-900"
    )
  end

  def trigger_icon_direction
    case @side
    when :top
      :up
    when :bottom
      :down
    when :left
      :left
    when :right
      :right
    end
  end

  def side_top? = @side == :top
  def side_bottom? = @side == :bottom
  def side_left? = @side == :left
  def side_right? = @side == :right
  def align_start? = @align == :start
  def align_center? = @align == :center
  def align_end? = @align == :end
  def side_vertical? = side_top? || side_bottom?
  def side_horizontal? = side_left? || side_right?
  def vertical_start? = side_vertical? && align_start?
  def vertical_center? = side_vertical? && align_center?
  def vertical_end? = side_vertical? && align_end?
  def horizontal_start? = side_horizontal? && align_start?
  def horizontal_center? = side_horizontal? && align_center?
  def horizontal_end? = side_horizontal? && align_end?
end