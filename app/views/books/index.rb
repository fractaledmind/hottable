module Views
  class Books::Index < Base
    def initialize(records:, search:, pagy:)
      @records = records
      @search = search
      @pagy = pagy
    end

    def template
      render Layout.new do
        div class: "bg-violet-700 flex flex-col flex-nowrap overflow-hidden h-full" do
          headline

          div class: "grow bg-violet-800 flex flex-col flex-nowrap overflow-hidden" do
            tabs

            div class: "grow bg-violet-100 flex flex-col overflow-hidden", data: { controller: "checkbox-set", checkbox_set_total_value: @search.result.size } do
              div class: "shrink flex justify-between items-center flex-wrap bg-white p-2 min-h-16 border-b" do
                render "books/form", search: @search
              end

              div class: "grow flex items-start -mt-px overflow-scroll", role: "region", aria: { labelledby: "booksTableCaption" }, tabindex: "0" do
                render Views::Table.new(@records, search: @search, pagy: @pagy)
              end
            end
          end
        end
      end
    end

    private

    def headline
      header class: "shrink text-white p-4 flex items-center justify-between" do
        a class: "min-w-0 flex-1", href: root_path do
          h2 "Workspace", class: "text-2xl font-bold leading-7 sm:truncate sm:text-3xl sm:tracking-tight"
        end
        div class: "mt-4 flex items-center md:mt-0 md:ml-4" do
          svg width: "40", height: "40", viewBox: "0 0 280 300", fill: "white", xmlns: "http://www.w3.org/2000/svg" do
            path d: "m130.17 75-68.56 28.4a4.59 4.59 0 0 0 .07 8.51l68.84 27.3a25.52 25.52 0 0 0 18.83 0l68.84-27.3a4.59 4.59 0 0 0 .07-8.51L149.7 75a25.52 25.52 0 0 0-19.53 0"
            path d: "M146 154.12v68.19a4.59 4.59 0 0 0 6.29 4.27L229 196.81a4.6 4.6 0 0 0 2.9-4.27v-68.2a4.6 4.6 0 0 0-6.29-4.27l-76.71 29.78a4.58 4.58 0 0 0-2.9 4.27"
            path d: "m128.13 157.64-22.77 11-2.31 1.11-48 23c-3 1.47-6.94-.75-6.94-4.13v-64a4.29 4.29 0 0 1 1.47-3.08 5.33 5.33 0 0 1 1.16-.87 4.9 4.9 0 0 1 4.18-.32l72.88 28.87a4.6 4.6 0 0 1 .38 8.41"
          end
          span "HotTable"
        end
      end
    end

    def tabs
      div class: "shrink" do
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
          nav class: "-mb-px flex space-x-0.5 px-4", 'aria-label': "Tabs" do
            div class: "relative z-40 bg-white text-gray-800 group rounded-t inline-flex items-center font-medium p-4", 'aria-current': "page" do
              span "Books"
            end
            details class: "relative z-40 border-transparent text-white hover:bg-violet-900 open:bg-violet-900 hover:border-white group rounded-t rounded-b-none inline-flex items-center border-b font-medium" do
              summary class: "marker:hidden cursor-pointer p-4" do
                div class: "flex items-center gap-1" do
                  render Bootstrap::Icon.new("plus-lg"), aria: { hidden: "true" }
                  text "Save view"
                end
              end
              div class: "absolute left-0 z-10 mt-1 w-72 origin-top-right divide-y divide-gray-100 rounded-md bg-white border-2 shadow-lg drop-shadow-lg focus:outline-none", role: "menu", aria: { orientation: "vertical", labelledby: "menu-button" }, tabindex: "-1" do
                  div class: "p-2" do
                    label "Name", for: "views_name", class: "block text-sm font-medium text-gray-700"
                    div class: "mt-1" do
                      input type: "text", name: "views[name]", id: "views_name", class: "block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500 sm:text-sm", placeholder: "e.g. 20th century English novels"
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
end
