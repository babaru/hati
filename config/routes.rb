Hati::Application.routes.draw do

  devise_for :users
  root :to => 'manager/gos#index'

  match 'go/:code', :to => 'go#index'
  match 'j/:code', :to => 'go#index'
  # match 'shorten', :to => 'go#shorten', :as => :shorten_url

  namespace :manager do
    resources :gos do
      resources :access_logs
    end

    resources :gos, :access_logs
  end

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
