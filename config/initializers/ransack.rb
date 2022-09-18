module Ransack
  module Nodes
    class Batch < Sort
      attr_reader :expanded

      def build(params)
        params.with_indifferent_access.each do |key, value|
          send("#{key}=", value) if key.match(/^(name|dir|ransacker_args|expanded)$/)
        end

        self
      end

      def expanded=(value)
        @expanded = value == 'true' ? true : false
      end
    end
  end

  class Search
    def build(params)
      collapse_multiparameter_attributes!(recursive_compact(params)).each do |key, value|
        if key == 's' || key == 'sorts'
          send(:sorts=, value)
        elsif key == 'f' || key == 'fields'
          send(:fields=, value)
        elsif key == 'b' || key == 'batch'
          next if value["name"].blank? && value["dir"].blank?

          send(:batch=, value)
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

    def batch=(args)
      @batch ||= nil

      case args
      when Hash
        @batch = Nodes::Batch.new(@context).build(args)
      when Nodes::Batch
        @batch = args
      end
    end
    alias_method :b=, :batch=

    def batch
      @batch ||= nil

      @batch
    end
    alias_method :b, :batch

    def build_batch(opts = {})
      new_batch(opts).tap do |batch|
        self.batch = batch
      end
    end

    def new_batch(opts = {})
      Nodes::Batch.new(@context).build(opts)
    end

    def default_fields=(args)
      @default_fields = args.map { |field| Nodes::Attribute.new(@context, field) }
    end

    def default_fields
      @default_fields ||= []
    end

    def fields=(args)
      @fields ||= default_fields
      @fields = [] if args == []

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
    alias_method :f=, :fields=

    def fields
      @fields ||= default_fields

      @fields
    end
    alias_method :f, :fields

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

    def batch_attribute
      batch.attr_name
    end

    def recursive_compact(hash_or_array)
      p = proc do |*args|
        v = args.last
        v.delete_if(&p) if v.respond_to? :delete_if
        v.nil? || v.respond_to?(:"empty?") && v.empty?
      end

      hash_or_array.delete_if(&p)
    end
  end
end
