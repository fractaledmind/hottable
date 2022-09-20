require "csv"

class BooksController < ApplicationController
  layout false
  before_action :set_data

  # GET /books
  def index
    render Views::Books::Index.new(
      search: @search,
      result: @result,
      records: @records,
      pagy: @pagy
    )
  end

  def edit
    book = Book.find(params[:id])
    parts = []

    attribute = params["book_attribute"]
    inline_edit = params["book_edit"] == "true"
    column_class = inline_edit ? Views::Table::ColumnEdit : Views::Table::Column

    html = column_class.new(book, search: ransack_search, attribute: attribute).call
    id = dom_id(book, "column_#{attribute}")

    parts << turbo_stream.replace(id, html)
    parts << turbo_stream.set_focus("##{id} input, ##{id} select") if inline_edit

    render turbo_stream: parts.join("")
  end

  def update
    book = Book.find(params[:id])

    if book.update(book_params)
      parts = []

      changed_attributes = book.previous_changes.keys - ["updated_at"]

      if changed_attributes.empty?
        changed_attributes << params["book_attribute"]
      end

      changed_attributes.each do |attribute|
        html = Views::Table::Column.new(book, search: ransack_search, attribute: attribute).call
        id = dom_id(book, "column_#{attribute}")

        parts << turbo_stream.replace(id, html)
      end

      render turbo_stream: parts.join(" ")
    end
  end

  # GET|POST /books/search
  def search
    redirect_to books_path(
      params.to_unsafe_hash.except(:view_name, :authenticity_token, :action, :controller, :commit, :filter, :batch, :field)
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
            when "min"
              data.select(params[:attribute]).minimum(params[:attribute])
            when "max"
              data.select(params[:attribute]).maximum(params[:attribute])
            when "avg"
              data.select(params[:attribute]).average(params[:attribute]).round(2)
            when "sum"
              data.select(params[:attribute]).sum(params[:attribute])
            when "earliest"
              data.select(params[:attribute]).reorder(params[:attribute] => :asc).limit(1).pluck(params[:attribute]).first
            when "latest"
              data.select(params[:attribute]).reorder(params[:attribute] => :desc).limit(1).pluck(params[:attribute]).first
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
    @result = begin
      _result = @search.result
      _result = _result.reorder(@search.batch.attr_name => @search.batch.dir) if @search.batch

      _result
    end
    @pagy, @records = pagy(@result, items: page_items)
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

  def page_items
    params.fetch(:page_items, Pagy::DEFAULT[:items])
  end
end
