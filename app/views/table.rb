module Views
  class Table < Base
    def initialize(records, search:, pagy:)
      @records = records
      @search = search
      @pagy = pagy
    end

    def template
      table class: "h-full min-w-full divide-y divide-gray-300" do
        caption id: "booksTableCaption", class: "h-0 overflow-hidden" do
          i class: "bi-table", aria_hidden: "true"
          "Main View"
        end

        render Views::Table::Head.new(search: @search)

        if @search.batch_attribute.present?
          @records.group_by(& @search.batch_attribute.to_sym).each do |group_name, group_records|
            tbody class: "divide-y divide-gray-200 bg-white" do
              render Views::Table::GroupHeader.new(group_name, group_records, search: @search)

              group_records.each do |record|
                render Views::Table::Row.new(record, search: @search)
              end
            end
          end
        else
          tbody class: "divide-y divide-gray-200 bg-white" do
            @records.each do |record|
              render Views::Table::Row.new(record, search: @search)
            end
          end
        end

        render Views::Table::Footer.new(@search, pagy: @pagy)
      end
    end
  end
end
