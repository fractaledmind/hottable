module Views
  class Bootstrap::Icon < Base
    def initialize(name, **attributes)
      @name, @attributes = name, attributes
    end

    def template
      i **@attributes.merge(class: "bi-#{@name}")
    end
  end
end
