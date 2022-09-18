class ViewsController < ApplicationController
  def create
    view = View.create(
      name: view_params[:name],
      parameters: view_parameters
    )

    redirect_to books_path(
      view_parameters.merge(
        current_view: view.name
      )
    )
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
