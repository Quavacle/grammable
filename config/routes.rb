Rails.application.routes.draw do
  devise_for :users
  root "grams#index"
  resource :grams
end
