Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :jobs

  namespace :admin do
    resources :jobs do
      member do
        patch :publish
        patch :hide
      end
    end
  end

  root "jobs#index"
end
