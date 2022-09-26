require "phlex/rails"

class ApplicationComponent < Phlex::Component
  include ActionView::Helpers::AssetUrlHelper
  include ActionView::RecordIdentifier
  include Rails.application.routes.url_helpers

  delegate :request, to: :@_view_context
  delegate :params, to: :@_view_context


  def attributify(*attribute_hashes)
    flat_attribute_hashes = attribute_hashes.map { flatten_attributes_hash(_1) }

    flat_attribute_hashes.reduce({}) do |memo, attribute_hash|
      memo.deep_merge(attribute_hash) do |attribute, oldval, newval|
        next newval unless ["class", "data-controller", "data-action"].include?(attribute)
        next newval if attribute.end_with?("!")
      
        [oldval, newval].uniq.join(' ')
      end
    end
  end

  def flatten_attributes_hash(input, keys = [], output = {})
    return output.merge!(keys.join('-') => input) unless input.is_a?(Hash)

    input.each do |key, value|
      name = case key
        when String
          key
        when Symbol
          key.name.tr("_", "-")
        else
          key.to_s
        end

      flatten_attributes_hash(
        value,
        keys + Array[name],
        output
      )
    end

    output
  end
end