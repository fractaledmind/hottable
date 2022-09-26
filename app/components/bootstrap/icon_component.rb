module Bootstrap
  class IconComponent < ApplicationComponent
    def initialize(name, decorative: true, **attributes)
      @name = name
      @decorative = decorative
      @attributes = attributes
    end

    def template
      i **attributify(icon_attributes, @attributes)
    end

    private

    def icon_attributes
      {
        class: "bi-#{@name}",
        aria: {
          hidden: @decorative,
        },
      }
    end
  end
end
