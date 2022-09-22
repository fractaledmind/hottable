module Views
  class Books::Tabs < ApplicationComponent
    def initialize(views)
      @views = views
    end

    def template
      div class: "sm:hidden px-2 space-y-2 mb-2" do
        label "Select a tab", for: "tabs", class: "sr-only"
        select id: "tabs", name: "tabs", class: "block w-full rounded-md border-gray-300 focus:border-indigo-500 focus:ring-indigo-500" do
          @views.each do |view|
            option view.name, selected: params[:current_view] == view.name || params[:current_view].nil? && view.name == "Books"
          end
        end
        render ButtonComponent.new(class: "w-full flex") do
          render Bootstrap::IconComponent.new("plus-lg")
          text "Add or import"
        end
      end
      div class: "hidden sm:block border-b border-gray-200" do
        nav id: "book_tabs", class: "-mb-px flex space-x-0.5 px-4", 'aria-label': "Tabs", data_controller: "details-set" do
          @views.each do |view|
            render Books::Tab.new(view)
          end

          div id: "new_tab"

          render(Books::TabPopover.new("New view", icon: "plus-lg")) do |t|
            t.body do
              div class: "p-2" do
                label "Name", for: "views_name", class: "block text-sm font-medium text-gray-700"
                div class: "mt-1" do
                  input type: "text", name: "views[name]", form: "searchForm", id: "views_name", class: "block w-full text-gray-900 rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500 sm:text-sm", placeholder: "e.g. 20th century English novels"
                end
              end

              div class: "flex items-center justify-end gap-2 py-2 px-4 bg-gray-200" do
                render ButtonComponent.new(as: :input, type: "submit", value: "Save", form: "searchForm", formaction: views_path, primary: true)
              end
            end
          end
        end
      end
    end
  end
end
