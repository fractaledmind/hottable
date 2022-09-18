class BooksController < ApplicationController
  layout false

  # GET /users
  def index
    search = Book.ransack(search_params)
    search.default_fields = Book.ransortable_attributes
    pagy, records = pagy(search.result, items: params.fetch(:page_items, 20))

    respond_to do |format|
      format.html do
        render Views::Books::Index.new(
          search: search,
          records: records,
          pagy: pagy
        )
      end
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace('table') {
          Views::Table.new(
            records,
            search: search,
            pagy: pagy
          ).call(view_context:).html_safe
        }
      end
    end
  end

  # GET|POST /users/search
  def search
    redirect_to books_path(
      params.to_unsafe_hash.except(:authenticity_token, :action, :controller, :commit, :filter, :batch, :field)
    )
  end

  def summarize
    search = Book.ransack(search_params)
    search.default_fields = Book.ransortable_attributes
    records = search.result

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

  def search_params
    q = params.fetch(:q, {})
    q[:f] ||= []
    q[:f].insert(0, Book.primary_attribute)
    q
  end
end
