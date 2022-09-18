class ViewsController < ApplicationController
  def create
    view = View.create(
      name: view_params[:name],
      parameters: params.to_unsafe_hash.except(:views, :authenticity_token, :controller, :action)
    )

    html = Views::Books::Tab.new(view).call(view_context:).html_safe

    render turbo_stream: turbo_stream.append("book_tabs", html)
  end

  private

  def view_params
    params.require(:views).permit(:name)
  end
end
