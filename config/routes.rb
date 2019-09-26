 Rails.application.routes.draw do
  devise_for :users
  resources :grams do
    resources :comments
  end 
   root "grams#index"
end
