Hati::Application.routes.draw do
  match 'go/:code', :to => 'go#index'
  match 'j/:code', :to => 'go#index'
  match 'shorten', :to => 'go#shorten', :as => :shorten_url

  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  devise_for :users

  root :to => 'rails_admin/main#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
