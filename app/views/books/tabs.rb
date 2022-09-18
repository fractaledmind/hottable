module Views
  class Books::Tabs < Base
    def initialize(views)
      @views = views
    end

    def template
      div class: "sm:hidden px-2 space-y-2 mb-2" do
        label "Select a tab", for: "tabs", class: "sr-only"
        select id: "tabs", name: "tabs", class: "block w-full rounded-md border-gray-300 focus:border-indigo-500 focus:ring-indigo-500" do
          option "Books", selected: true
        end
        button type: "button", class: "w-full flex items-center rounded-none rounded border border-gray-300 bg-gray-200 py-2 px-4 text-base font-bold text-gray-900 shadow-sm hover:bg-gray-300" do
          svg class: "w-4 h-4", xmlns: "http://www.w3.org/2000/svg", fill: "none", viewBox: "0 0 24 24", 'stroke-width': "4", stroke: "currentColor" do
            path stroke: { linecap: "round", linejoin: "round" }, d: "M12 4.5v15m7.5-7.5h-15"
          end
          text "Add or import"
        end
      end
      div class: "hidden sm:block border-b border-gray-200" do
        nav id: "book_tabs", class: "-mb-px flex space-x-0.5 px-4", 'aria-label': "Tabs", data_controller: "details-set" do
          @views.each do |view|
            render Books::Tab.new(view)
          end

          div id: "new_tab"

          render(Books::TabDropdown.new("New view", icon: "plus-lg")) do |t|
            t.body do
              div class: "p-2" do
                label "Name", for: "views_name", class: "block text-sm font-medium text-gray-700"
                div class: "mt-1" do
                  input type: "text", name: "views[name]", form: "searchForm", id: "views_name", class: "block w-full text-gray-900 rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500 sm:text-sm", placeholder: "e.g. 20th century English novels"
                end
              end

              div class: "flex items-center justify-end gap-2 py-2 px-4 bg-gray-200" do
                input type: "submit", value: "Save", form: "searchForm", formaction: views_path, class: "inline-flex items-center rounded-md border border-transparent bg-blue-500 hover:bg-blue-400 text-white px-2.5 py-1.5 text-base font-medium text-gray-900 gap-2"
              end
            end
          end
        end
      end
    end
  end
end
