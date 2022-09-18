require "csv"

class BooksController < ApplicationController
  layout false
  before_action :set_data

  # GET /books
  def index
    render Views::Books::Index.new(
      search: @search,
      records: @records,
      pagy: @pagy
    )
  end

  def edit
    book = Book.find(params[:id])
    parts = []

    if true # type == "column"
      attribute = params["book_attribute"]
      column_class = params["book_edit"] == "true" ? Views::Table::ColumnEdit : Views::Table::Column

      html = column_class.new(book, search: ransack_search, attribute: attribute).call(view_context:).html_safe
      id = dom_id(book, "column_#{attribute}")

      parts << turbo_stream.replace(id, html)
      parts << turbo_stream.set_focus("##{id} input")
    else
      html = Views::Table::Row.new(book, search: ransack_search, inline_edit: true).call(view_context:).html_safe
      id = dom_id(book, :row)

      parts << turbo_stream.replace(id, html)
    end

    render turbo_stream: parts.join("")
  end

  def update
    book = Book.find(params[:id])

    if book.update(book_params)
      parts = []

      if true # type == "column"
        changed_attributes = book.previous_changes.keys - ["updated_at"]

        if changed_attributes.empty?
          changed_attributes << params["book_attribute"]
        end

        changed_attributes.each do |attribute|
          html = Views::Table::Column.new(book, search: ransack_search, attribute: attribute).call(view_context:).html_safe
          id = dom_id(book, "column_#{attribute}")

          parts << turbo_stream.replace(id, html)
        end
      else
        html = Views::Table::Row.new(book, search: ransack_search).call(view_context:).html_safe
        id = dom_id(book, :row)

        parts << turbo_stream.replace(id, html)
      end

      render turbo_stream: parts.join(" ")
    else
      throw
    end
  end

  # GET|POST /books/search
  def search
    redirect_to books_path(
      params.to_unsafe_hash.except(:authenticity_token, :action, :controller, :commit, :filter, :batch, :field)
    )
  end

  # GET books/export
  def summarize
    data = @search.result
    total = case params[:calculation]
            when ""
            when "nil"
              data.where(params[:attribute] => nil).size
            when "not_nil"
              data.where.not(params[:attribute] => nil).size
            when "unique"
              data.select(params[:attribute]).distinct.reorder(nil).size
            end

    render turbo_stream: turbo_stream.replace([params[:attribute], "summary"].join("_")) {
      Views::Table::ColumnSummary.new(
        total,
        attribute: params[:attribute],
        calculation: params[:calculation],
      ).call(view_context:).html_safe
    }
  end

  # GET books/export
  def export
    data = params[:selectAll].present? ? @search.result : @records.where(id: params.fetch(:select, {}).keys)

    respond_to do |format|
      format.csv do
        send_data data.to_csv(@search.field_attributes), filename: "books-#{Time.now.utc.to_formatted_s(:number)}.csv", disposition: (Rails.env.development? ? :inline : :attachment)
      end
    end
  end

  private

  def set_data
    @search = ransack_search
    @pagy, @records = pagy(@search.result, items: params.fetch(:page_items, Pagy::DEFAULT[:items]))
  end

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
