module Views
  class Books::Tab < Base
    delegate :request, to: :@_view_context
    delegate :params, to: :@_view_context

    def initialize(view)
      @view = view
    end

    def template
      a id: tab_id, href: books_path(@view&.parameters),
        **classes("relative z-40 group rounded-t inline-flex items-center font-medium text-white border-b border-transparent p-4  hover:border-white",
          current_page?: "bg-white text-gray-800 hover:bg-gray-100",
          -> { !current_page? } => "hover:bg-violet-900"),
        aria_current: tokens(current_page?: "page") do
        span @view.name
      end
    end

    private

    def tab_id
      dom_id(@view, :tab)
    rescue
      "default_tab"
    end

    def current_page?
      clean_params = params.to_unsafe_hash.except(:views, :authenticity_token, :controller, :action)
      clean_params == @view&.parameters
    end
  end
end
