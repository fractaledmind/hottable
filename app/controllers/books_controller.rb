class BooksController < ApplicationController
  def index
    @pagy, @records = pagy(Book.all)
  end
end
