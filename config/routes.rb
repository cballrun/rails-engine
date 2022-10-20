Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do
      get "/merchants/find", to: "merchants#find"
      resources :merchants, only: [:index, :show] do
        resources :items, only: [:index], controller: :merchant_items
      end
      get "/items/find_all", to: "items#find_all"
      resources :items, only: [:index, :show, :create, :destroy, :update] do
        resources :merchant, only: [:index], controller: :items_merchant
      end
    end
  end

end
