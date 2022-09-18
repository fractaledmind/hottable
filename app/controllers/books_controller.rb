class BooksController < ApplicationController
  layout false

  # GET /users
  def index
    pagy, records = pagy(ransack_search.result, items: params.fetch(:page_items, 20))

    respond_to do |format|
      format.html do
        render Views::Books::Index.new(
          search: ransack_search,
          records: records,
          pagy: pagy
        )
      end
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace('table') {
          Views::Table.new(
            records,
            search: ransack_search,
            pagy: pagy
          ).call(view_context:).html_safe
        }
      end
    end
  end

  def edit
    book = Book.find(params[:id])

    if true # type == "column"
      attribute = params["book"]["attribute"]

      html = Views::Table::ColumnEdit.new(book, search: ransack_search, attribute: attribute).call(view_context:).html_safe
      id = dom_id(book, "column_#{attribute}")
    else
      html = Views::Table::Row.new(book, search: ransack_search, inline_edit: true).call(view_context:).html_safe
      id = dom_id(book, :row)
    end

    render turbo_stream: turbo_stream.replace(id, html)
  end

  def update
    book = Book.find(params[:id])

    if book.update(book_params)
      row = Views::Table::Row.new(book, search: ransack_search).call(view_context:).html_safe
      render turbo_stream: turbo_stream.replace(dom_id(book, :row), row)
    else
      throw
    end
  end

  # GET|POST /users/search
  def search
    redirect_to books_path(
      params.to_unsafe_hash.except(:authenticity_token, :action, :controller, :commit, :filter, :batch, :field)
    )
  end

  def summarize
    records = ransack_search.result

    total = case params[:calculation]
            when ""
            when "nil"
              records.where(params[:attribute] => nil).size
            when "not_nil"
              records.where.not(params[:attribute] => nil).size
            when "unique"
              records.select(params[:attribute]).distinct.size
            end

    render turbo_stream: turbo_stream.replace([params[:attribute], "summary"].join("_")) {
      Views::Table::ColumnSummary.new(
        total,
        attribute: params[:attribute],
        calculation: params[:calculation],
      ).call(view_context:).html_safe
    }
  end

  private

  def book_params
    params.require(:book).permit(
      :title,
      :average_rating,
      :isbn,
      :isbn13,
      :language_code,
      :num_pages,
      :ratings_count,
      :text_reviews_count,
      :published_on,
      :publisher,
    )
  end

  def ransack_search
    @_search ||= begin
      _search = Book.order(id: :asc).ransack(search_params)
      _search.default_fields = Book.ransortable_attributes

      _search
    end
  end

  def search_params
    q = params.fetch(:q, {})
    q[:f] ||= []
    q[:f].insert(0, Book.primary_attribute) if q[:f].any?
    q
  end
end
