class ViewsController < ApplicationController
  def create
    View.create(
      name: params[:view_name],
      parameters: params.to_unsafe_hash.except(:view_name).to_json
    )
  end
end
