class ViewsController < ApplicationController
  def create
    view = View.create(
      name: create_view_params[:name],
      parameters: view_parameters.merge(
        current_view: create_view_params[:name]
      )
    )

    redirect_to books_path(
      view.parameters
    )
  end

  def update
    view = View.find(params[:id])
    view.update(
      name: update_view_params[:name],
      parameters: view_parameters.merge(
        current_view: update_view_params[:name]
      )
    )

    redirect_to books_path(
      view_parameters.merge(
        current_view: view.name
      )
    )
  end

  def destroy
    View.find(params[:id]).destroy
    redirect_to root_path
  end

  private

  def create_view_params
    params.require(:views).permit(:id, :name)
  end
  
  def update_view_params
    view_params = params.require(:views).to_unsafe_hash
    view_params.fetch(params[:id], {})
  end

  def view_parameters
    params.to_unsafe_hash.except(:authenticity_token, :controller, :action)
  end
end
