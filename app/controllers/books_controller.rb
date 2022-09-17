class BooksController < ApplicationController
  def index
    @search = Book.ransack(params[:q])
    @pagy, @records = pagy(@search.result)
  end
end
