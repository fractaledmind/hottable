module Views
  class Books::Form::Section::Heading< ApplicationComponent
    def template(&block)
      h3 class: "border-b mb-2 pb-1 font-bold px-2 py-1", &block
    end
  end
end
