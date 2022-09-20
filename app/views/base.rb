require "phlex/rails"

module Views
  class Base < Phlex::Component
    include ActionView::Helpers::AssetUrlHelper
    include ActionView::RecordIdentifier
    include Rails.application.routes.url_helpers
  end
end
