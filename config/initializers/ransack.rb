module Ransack
  class Search
    def build(params)
      collapse_multiparameter_attributes!(params).each do |key, value|
        if ['s'.freeze, 'sorts'.freeze].freeze.include?(key)
          send("#{key}=", value)
        elsif ['f'.freeze, 'fields'.freeze].freeze.include?(key)
          send("#{key}=", value)
        elsif @context.ransackable_scope?(key, @context.object)
          add_scope(key, value)
        elsif base.attribute_method?(key)
          base.send("#{key}=", value)
        elsif !Ransack.options[:ignore_unknown_conditions] || !@ignore_unknown_conditions
          raise ArgumentError, "Invalid search term #{key}"
        end
      end
      self
    end


    def default_fields=(args)
      @default_fields = args.map { |field| Nodes::Attribute.new(@context, field) }
    end

    def default_fields
      @default_fields ||= []
    end

    def fields=(args)
      @fields ||= default_fields

      args.each do |field|
        case field
        when Hash
          field = Nodes::Attribute.new(@context, field['name'])
        when String
          next if field == ''
          field = Nodes::Attribute.new(@context, field)
        end

        fields << field
      end
    end
    alias f= fields=

    def fields
      @fields ||= default_fields

      @fields
    end
    alias f fields

    def build_field(opts = {})
      new_field(opts).tap do |field|
        fields << field
      end
    end

    def new_field(opts = {})
      Nodes::Attribute.new(@context, opts)
    end

    def condition_attributes
      groupings_attr_names = groupings.flat_map { |g| g.conditions.flat_map { |c| c.attributes.map(&:attr_name) } }
      conditions_attr_names = conditions.flat_map { |c| c.attributes.map(&:attr_name) }
      (groupings_attr_names + conditions_attr_names).uniq
    end

    def sort_attributes
      sorts.map(&:attr_name).uniq
    end

    def field_attributes
      fields.map(&:name).uniq
    end

    def hidden_fields
      default_fields - fields
    end

  end
end
