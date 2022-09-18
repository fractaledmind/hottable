class ApplicationController < ActionController::Base
  include Pagy::Backend
  include ActionView::RecordIdentifier
end
