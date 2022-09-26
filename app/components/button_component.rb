class ButtonComponent < ApplicationComponent
  class Struct < ApplicationComponent::Struct
    def initialize(primary: false)
      @primary = primary
    end
    
    def base
      {
        class: tokens(
          "cursor-pointer inline-flex items-center rounded-md border border-transparent px-2.5 py-1.5 text-base font-medium gap-2",
          primary?: "bg-blue-500 hover:bg-blue-400 text-white",
          default?: "bg-gray-200 hover:bg-gray-300 text-gray-900"
        ),
      }
    end
    
    private
    
    def primary? = !!@primary
    def default? = !primary?
  end

  def self.struct(*args, **kwargs)
    Struct.new(*args, **kwargs)
  end

  def initialize(text = nil, as: :button, primary: false, icon: nil, **attributes)
    @text = text
    @element = as
    @primary = primary
    @icon = icon
    @attributes = attributes
  end

  def template(&block)
    if block_given?
      public_send(@element, **button_attributes, &block)
    else
      public_send(@element, **button_attributes) do
        render Bootstrap::IconComponent.new(@icon) if @icon
        text @text
      end
    end
  end

  def struct
    self.class.struct(primary: @primary)
  end

  private

  def button_attributes
    attributify(struct.base, @attributes)
  end
end
