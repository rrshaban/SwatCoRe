Rails.application.routes.draw do

  root               'static_pages#home'
  get 'help'      => 'static_pages#help'
  get 'about'     => 'static_pages#about'
  get 'contact'   => 'static_pages#contact'
  get 'signup'    => 'users#new'
  get 'login'     => 'sessions#new'
  post 'login'    => 'sessions#create'
  delete 'logout' => 'sessions#destroy'

  resources :users


  # below is the hierarchy: depts > professors > courses > reviews
  # once we thoroughly seed depts and professors, we can delete 
  resources :departments, only: [:index, :show, :new, :create]  # :new and :create
  resources :professors, only: [:index, :show, :new, :create]
  resources :courses

  resources :reviews, only: [:create, :destroy]

end
