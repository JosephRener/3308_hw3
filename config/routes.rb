Rottenpotatoes::Application.routes.draw do
  # The priority is based upon order of creation:
  # first created -> highest priority.

  resources :movies do
      get 'sort/:order_by', to: 'movies#index', as: 'sort', on: :collection
  end

end
