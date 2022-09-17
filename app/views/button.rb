module Views
  class Button < Base
    def initialize(text, primary: false)
      @text = text
      @primary = primary
    end

    def template
      button @text, **classes("inline-flex items-center rounded-md border border-transparent bg-gray-200 px-2.5 py-1.5 text-base font-medium text-gray-900 hover:bg-gray-300",
        primary?: "bg-blue-500 hover:bg-blue-400 text-white")
    end

    def primary? = !!@primary
  end
end
