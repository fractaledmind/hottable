class ButtonComponent < ApplicationComponent
  def self.attributes
    {
      type: "button",
      class: [
        "cursor-pointer inline-flex items-center rounded-md border border-transparent px-2.5 py-1.5 text-base font-medium gap-2",
        primary?: "bg-blue-500 hover:bg-blue-400 text-white",
        default?: "bg-gray-200 hover:bg-gray-300 text-gray-900"
      ],
    }
  end

  def initialize(as: :button, primary: false, **attributes)
    @element = as
    @primary = primary
    @attributes = attributes
  end

  def template(&)
    public_send(@element, **button_attributes, &)
  end

  private

  def button_attributes
    default_attributes = self.class.attributes.transform_values do |attribute_value|
      case attribute_value
      when String then attribute_value
      when Array then tokens(*attribute_value[0..-2], **attribute_value[-1])
      end
    end
    merge_attributes(default_attributes, @attributes)
  end

  def primary? = !!@primary
  def default? = !primary?
end
