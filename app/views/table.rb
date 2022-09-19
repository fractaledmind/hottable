module Views
  class Table < Base
    def initialize(records, result:, search:, pagy:)
      @records = records
      @result = result
      @search = search
      @pagy = pagy
    end

    def template
      table class: "h-full border-r border-gray-300", id: 'table' do
        caption id: "booksTableCaption", class: "h-0 overflow-hidden" do
          i class: "bi-table", aria_hidden: "true"
          "Main View"
        end

        render Views::Table::Head.new(search: @search)

        if @search.batch_attribute.present?
          group_counts = @result.reorder('').group(@search.batch_attribute).order("books_#{@search.batch_attribute}" => :desc).count
          @records.reorder(@search.batch.attr_name => @search.batch.dir).group_by(& @search.batch_attribute.to_sym).each do |group_name, group_records|
            tbody class: "bg-white", data_controller: "groupable" do
              render Views::Table::GroupHeader.new(group_name, group_counts[group_name], search: @search)

              group_records.each do |record|
                render Views::Table::Row.new(record, search: @search, expanded: @search.batch.expanded)
              end
              tr aria_hidden: "true", class: "bg-violet-100 h-full" do
                td colspan: attributes.size + 1, class: "p-0 bg-none"
              end
            end
          end
        else
          tbody class: "bg-white" do
            @records.each do |record|
              render Views::Table::Row.new(record, search: @search)
            end
            tr aria_hidden: "true", class: "bg-violet-100 h-full" do
              td colspan: attributes.size + 1, class: "p-0 bg-none"
            end
          end
        end

        tfoot class: "sticky bottom-0 z-20 bg-gray-100" do
          tr class: "h-12" do
            td do
            end
            attributes.each do |attribute|
              render Views::Table::ColumnSummary.new(nil, attribute: attribute, calculation: "")
            end
          end
        end
        render Views::Table::Footer.new(@search, pagy: @pagy)
      end
    end

    private

    def attributes = @search.field_attributes
  end
end
