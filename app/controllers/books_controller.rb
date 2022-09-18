class BooksController < ApplicationController
  layout false

  # GET /users
  def index
    search = Book.ransack(search_params)
    search.default_fields = Book.ransortable_attributes
    pagy, records = pagy(search.result, items: params.fetch(:page_items, 20))

    render Views::Books::Index.new(
      search: search,
      records: records,
      pagy: pagy
    )
  end

  # GET|POST /users/search
  def search
    redirect_to books_path(
      params.to_unsafe_hash.except(:authenticity_token, :action, :controller, :commit, :filter, :batch)
    )
  end

  private

  def search_params
    q = params.fetch(:q, {})
    q[:f] = [Book.primary_attribute] if q.fetch(:f, []) == [""]
    q
  end
end
