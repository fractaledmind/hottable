class ViewsController < ApplicationController
  def create
    view = View.create(
      name: view_params[:name],
      parameters: view_parameters
    )

    parts = []
    html = Views::Books::Tab.new(view).call(view_context:).html_safe

    parts << turbo_stream.prepend("new_tab", html)

    html = Views::Books::Tab.new(OpenStruct.new(name: "Books", parameters: {})).call(view_context:).html_safe

    parts << turbo_stream.replace("default_tab", html)
    render turbo_stream: parts.join(" ")
  end

  def update
    View.find(view_params[:id]).update(parameters: view_parameters)
  end

  def destroy
    View.find(view_params[:id]).destroy
  end

  private

  def view_params
    params.require(:views).permit(:id, :name)
  end
  
  def view_parameters
    params.to_unsafe_hash.except(:authenticity_token, :controller, :action)
  end
end
