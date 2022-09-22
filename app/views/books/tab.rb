module Views
  class Books::Tab < ApplicationComponent
    def initialize(view)
      @view = view
    end

    def template
      if current_page?
        render(Books::TabDropdown.new(@view.name, active: current_page?)) do |t|
          t.body do
            div class: "block group-has-peer-checked:hidden divide-y divide-gray-100" do
              div class: "py-1" do
                label for: "rename_#{@view_name}", class: "cursor-pointer text-gray-700 group flex items-center px-4 py-2 space-x-2 hover:bg-gray-200", role: "menuitem", tabindex: "-1" do
                  render Bootstrap::IconComponent.new("pencil")
                  span "Rename view"
                  input id: "rename_#{@view_name}", type: "checkbox", checked: false, class: "sr-only peer"
                end
                button type: "submit", form: "searchForm", formaction: view_path(@view.id), class: "w-full text-gray-700 group flex items-center px-4 py-2 space-x-2 hover:bg-gray-200", role: "menuitem", tabindex: "-1" do
                  render Bootstrap::IconComponent.new("sliders2")
                  span "Update view"
                end
              end
              unless @view.name == "Books!"
                div class: "py-1" do
                  a href: view_path(@view.id), class: "text-gray-700 group flex items-center px-4 py-2 space-x-2 hover:bg-red-200 hover:text-red-700", role: "menuitem", tabindex: "-1", data_turbo_method: "delete" do
                    render Bootstrap::IconComponent.new("trash")
                    span "Delete view"
                  end
                end
              end
            end

            div class: "hidden group-has-peer-checked:block" do
              div class: "p-2" do
                label "Name", for: "views_name", class: "block text-sm font-medium text-gray-700"
                div class: "mt-1" do
                  input type: "text", value: @view.name, name: "views[#{@view.id}][name]", form: "searchForm", id: "views_name", class: "block w-full text-gray-900 rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500 sm:text-sm", placeholder: "e.g. 20th century English novels"
                end
              end
              
              div class: "flex items-center justify-end gap-2 py-2 px-4 bg-gray-200" do
                input type: "submit", value: "Save", form: "searchForm", formaction: view_path(@view.id), class: "inline-flex items-center rounded-md border border-transparent bg-blue-500 hover:bg-blue-400 text-white px-2.5 py-1.5 text-base font-medium text-gray-900 gap-2"
              end
            end
          end
        end
      else
        a id: tab_id, href: books_path(@view.parameters.merge(current_view: @view.name)),
          **classes("relative z-40 group rounded-t inline-flex items-center font-medium text-white border-b border-transparent px-4 py-2 hover:border-white hover:bg-violet-900",
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
