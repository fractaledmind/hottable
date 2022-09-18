class ViewsController < ApplicationController
  def create
    View.create(
      name: view_params[:name],
      parameters: params.to_unsafe_hash.except(:views, :authenticity_token, :controller, :action)
    )
  end

  private

  def view_params
    params.require(:views).permit(:name)
  end
end
