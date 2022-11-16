module Views
  class Books::Index < ApplicationComponent
    def initialize(records:, result:, search:, pagy:)
      @records = records
      @result = result
      @search = search
      @pagy = pagy
    end

    def template
      render Layout.new do
        div class: "bg-violet-700 flex flex-col flex-nowrap overflow-hidden h-full" do
          headline

          div class: "grow bg-violet-800 flex flex-col flex-nowrap overflow-hidden" do
            tabs

            div class: "grow bg-violet-100 flex flex-col overflow-hidden", data: { controller: "checkbox-set", checkbox_set_total_value: @result.size } do
              div class: "shrink flex justify-between items-center flex-wrap bg-white p-2 min-h-16 border-b" do
                render "books/form", search: @search
              end

              div class: "grow flex items-start -mt-px overflow-scroll", role: "region", aria: { labelledby: "booksTableCaption" }, tabindex: "0" do
                render Views::Table.new(@records, result: @result, search: @search, pagy: @pagy)
              end
            end
          end
        end
      end
    end

    private

    def headline
      header class: "shrink text-white px-4 py-2 flex items-center justify-between" do
        a class: "min-w-0", href: root_path do
          h2(class: "text-xl font-bold leading-7 sm:truncate sm:text-2xl sm:tracking-tight") { "Workspace" }
        end
        div class: "mt-4 flex items-center md:mt-0 md:ml-4" do
          svg width: "40", height: "40", viewBox: "0 0 280 300", fill: "white", xmlns: "http://www.w3.org/2000/svg" do
            path d: "m130.17 75-68.56 28.4a4.59 4.59 0 0 0 .07 8.51l68.84 27.3a25.52 25.52 0 0 0 18.83 0l68.84-27.3a4.59 4.59 0 0 0 .07-8.51L149.7 75a25.52 25.52 0 0 0-19.53 0"
            path d: "M146 154.12v68.19a4.59 4.59 0 0 0 6.29 4.27L229 196.81a4.6 4.6 0 0 0 2.9-4.27v-68.2a4.6 4.6 0 0 0-6.29-4.27l-76.71 29.78a4.58 4.58 0 0 0-2.9 4.27"
            path d: "m128.13 157.64-22.77 11-2.31 1.11-48 23c-3 1.47-6.94-.75-6.94-4.13v-64a4.29 4.29 0 0 1 1.47-3.08 5.33 5.33 0 0 1 1.16-.87 4.9 4.9 0 0 1 4.18-.32l72.88 28.87a4.6 4.6 0 0 1 .38 8.41"
          end
          span { "HotTable" }
        end
      end
    end

    def tabs
      div class: "shrink" do
        render Books::Tabs.new(View.all.order(created_at: :asc))
      end
    end
  end
end
