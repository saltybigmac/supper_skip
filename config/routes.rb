Rails.application.routes.draw do
  root to: "homepage#index"
  resources :users, only: [:new, :create]

  get "/login"  => "sessions#new"
  post "/login"  => "sessions#create"
  delete "/logout" => "sessions#destroy"
  get "/login_for_cart" => "sessions#new"
  get "/checkout_after_login" => "orders#create"
  get "/menu" => "items#menu"

  get "/admin" => "admin#index"

  get "/cart" => "cart_items#index"
  post "/cart" => "cart_items#create"
  post "/remove_item" => "cart_items#destroy"
  post "/update_item" => "cart_items#update"

  resources :items, only: [:show]
  resources :orders, only: [:show, :new, :create, :index]

  # namespace :admin do
  #   resources :restaurants, param: :slug do
  #     resources :items, only: [:index, :new, :create, :edit, :update], param: :slug
  #   end
  # end

  namespace :admin do
    post "/orders/:status" => "orders#filter", as: "filter_order"
    put "/orders/:id" => "orders#update", as: "update_order"
    get "/orders/:status" => "orders#filter", as: "order"
    get "/users" => "users#index"
    get "/users/:id" => "users#show", as: "show_user"
    resources :restaurants, only: [:show, :edit, :update], param: :slug do
      resources :categories, controller: "restaurant_categories"
      resources :items, only: [:index, :new, :create, :edit, :update], controller: "restaurant_items"
    end
  end

  resources :restaurants, only: [:new, :create, :show], param: :slug

  get "*rest" => "homepage#not_found"
end
