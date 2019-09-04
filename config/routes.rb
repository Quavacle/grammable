Rails.application.routes.draw do
  root "grams#index"
  resource :grams
end
