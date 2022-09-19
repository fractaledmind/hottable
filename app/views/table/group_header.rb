module Views
  class Table
    class GroupHeader < Base
      def initialize(group_name, group_count, search:)
        @group_name = group_name
        @group_count = group_count
        @search = search
      end

      def template
        tr class: "bg-gray-100 sticky top-12 z-10 bg-gray-100" do
          th colspan: "2", scope: "rowgroup", class: "sticky left-0 p-0 align-middle bg-gray-100" do
            button class: "p-2 w-full flex items-center border-r border-gray-300",
                   aria_haspopup: "true",
                   aria_expanded: @search.batch.expanded.to_s,
                   data_action: "groupable#toggle",
                   data_groupable_target: "button" do
              span class: "mr-6 ml-2" do
                i class: "expanded:bi-chevron-down bi-chevron-right"
              end
              div class: "flex flex-1 items-center justify-between" do
                div class: "flex flex-col text-left" do
                  small Book.human_attribute_name(@search.batch_attribute), class: "uppercase font-bold text-gray-600"
                  span @group_name.to_s, class: "h5 mb-0 whitespace-nowrap"
                end
                div class: "space-x-1" do
                  small "Count", class: "font-normal text-gray-500"
                  span @group_count.to_s, class: "monospace-numbers inline-flex items-center rounded-full bg-gray-300 px-2.5 py-0.5 text-xs font-medium text-gray-900 monospace-numbers"
                end
              end
            end
          end
          if (@search.field_attributes.size - 1) > 0
            td colspan: @search.field_attributes.size - 1
          end
        end
      end
    end
  end
end
