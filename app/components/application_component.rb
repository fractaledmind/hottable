require "phlex/rails"

class ApplicationComponent < Phlex::Component
  include ActionView::Helpers::AssetUrlHelper
  include ActionView::RecordIdentifier
  include Rails.application.routes.url_helpers

  def merge_attributes(default_attributes, provided_attributes)
    flat_default_attributes = flatten_keys_of(default_attributes)
    flat_provided_attributes = flatten_keys_of(provided_attributes)

    flat_default_attributes.deep_merge(flat_provided_attributes) do |attribute, oldval, newval|
      next newval unless ["class", "data-controller"].include?(attribute)
      next newval if attribute.end_with?("!")

      [newval, oldval].uniq.join(' ')
    end
  end

  def flatten_keys_of(input, keys = [], output = {})
    return output.merge!(keys.join('-') => input) unless input.is_a?(Hash)

    input.each do |key, value|
      flatten_keys_of(
        value,
        keys + Array[key],
        output
      )
    end
  
    output
  end
end