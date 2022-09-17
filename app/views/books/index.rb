module Views
  class Books::Index < Base
    def initialize(records:, search:, pagy:)
      @records = records
      @search = search
      @pagy = pagy
    end

    def template
      render Layout.new do
        h1 "Books#index"
        render "books/form", search: @search

        div class: "grow flex items-start -mt-px", role: "region", aria: { labelledby: "booksTableCaption" }, tabindex: "0" do
          render Views::Table.new(@records, search: @search, pagy: @pagy)
        end
      end
    end
  end
end
