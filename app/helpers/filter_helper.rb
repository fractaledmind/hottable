module FilterHelper
  def button_to_add_fields(form, type)
    new_object = form.object.send("build_#{type}")
    name = "#{type}_fields"
    fields = form.send(name, new_object, child_index: "new_#{type}") do |builder|
      render("filter/#{name}", f: builder)
    end

    tag.button(class: ['add_fields space-x-2', button_classes],
               data: { field_type: type, action: 'filter-by#addFields', content: "#{fields}" }) do
      safe_join([
        tag.i(class: 'bi-plus-lg', aria: { hidden: true }),
        tag.span(button_label[type])
      ])
    end
  end

  def button_to_remove_fields(labeled: true)
    tag.button(class: ['remove_fields space-x-2', button_classes, ('border border-transparent' if labeled)], data: { action: 'filter-by#removeFields' }) do
      safe_join([
        tag.i(class: 'bi-trash', aria: { hidden: true }),
        (tag.span("Remove") if labeled)
      ])
    end
  end

  def button_to_nest_fields(type)
    tag.button(class: ['nest_fields space-x-2', button_classes], data: { field_type: type, action: 'filter-by#nestFields' }) do
      safe_join([
        tag.i(class: 'bi-plus-lg', aria: { hidden: true }),
        button_label[type]
      ])
    end
  end

  def button_label
    {
      value: 'Add Value',
      condition: 'Add Condition',
      sort: 'Add another sort',
      grouping: 'Add Condition Group'
    }.freeze
  end

  def button_classes
    'inline-flex items-center rounded bg-black/10 px-2.5 py-1.5 text-sm font-medium whitespace-nowrap text-gray-900 hover:bg-black/20'
  end
end