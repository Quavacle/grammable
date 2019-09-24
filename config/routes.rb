 Rails.application.routes.draw do
  devise_for :users
  root "grams#index"
  resource :grams do
    resource :comments, only: :create
  end 
end
