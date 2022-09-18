module Views
  class Books::Tab < Base
    delegate :request, to: :@_view_context
    delegate :params, to: :@_view_context

    def initialize(view)
      @view = view
    end

    def template
      if current_page?
        render(Books::TabDropdown.new(@view.name, active: current_page?)) do |t|
          t.body do
            div class: "flex items-center justify-end gap-2 py-2 px-4 bg-gray-200" do
              input type: "submit", value: "Update", form: "searchForm", formaction: view_path(@view.id), class: "inline-flex items-center rounded-md border border-transparent bg-blue-500 hover:bg-blue-400 text-white px-2.5 py-1.5 text-base font-medium text-gray-900 gap-2"

              unless @view.name == "Books"
                a "Delete", href: view_path(@view.id), data: {
                  turbo: {
                    method: "delete"
                  }
                }
              end
            end
          end
        end
      else
        a id: tab_id, href: books_path(@view.parameters.merge(current_view: @view.name)),
          **classes("relative z-40 group rounded-t inline-flex items-center font-medium text-white border-b border-transparent p-4  hover:border-white hover:bg-violet-900",
            current_page?: "bg-white text-gray-800 hover:bg-gray-100"),
          aria_current: tokens(current_page?: "page") do
          span @view.name
        end
      end
    end

    private

    def tab_id
      dom_id(@view, :tab)
    rescue
      "default_tab"
    end

    def current_page?
      return true if params[:current_view].nil? && @view.name == "Books"

      params[:current_view] == @view.name
    end
  end
end
