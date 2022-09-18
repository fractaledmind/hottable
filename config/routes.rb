Rails.application.routes.draw do
  resources :books, only: [:index, :update, :edit] do
    collection do
      match 'search' => 'books#search', via: [:get, :post], as: :search
      get :summarize
      get :export
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "books#index"
end
