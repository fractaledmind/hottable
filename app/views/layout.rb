module Views
  class Layout < ApplicationComponent
    include Propshaft::Helper
    include ActionView::Helpers::AssetTagHelper

    def template(&)
      doctype

      html do
        head do
          title "HotTable"
          meta name: "viewport", content: "width=device-width, initial-scale=1"
          csp_meta_tag
          csrf_meta_tags
          link href: asset_path("favicon.ico"), rel: "icon", type: "image/x-icon"

          link rel: "stylesheet",
            href: stylesheet_path("application"),
            data: { turbo_track: "reload" }

          link rel: "stylesheet",
            href: "https://cdn.jsdelivr.net/npm/bootstrap-icons@1.9.1/font/bootstrap-icons.css"

          script type: "text/javascript",
            src: javascript_path("application"),
            data: { turbo_track: "reload" },
            defer: "defer"
        end

        body do
          content(&)
        end
      end
    end
  end
end
