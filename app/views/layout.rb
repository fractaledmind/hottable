module Views
  class Layout < Base
    include Propshaft::Helper

    def template(&)
      doctype

      html do
        head do
          title "HotTable"
          meta name: "viewport", content: "width=device-width, initial-scale=1"
          csp_meta_tag
          csrf_meta_tags

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
