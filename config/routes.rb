Rails.application.routes.draw do

  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }, path: "user", path_names: { 
    sign_in:      'let_me_in', 
    sign_out:     'bye', 
    sign_up:      'cmon_let_me_in',
    login:        'let_me_in', 
    password:     'secret', 
    confirmation: 'verification', 
    unlock:       'unblock', 
    registration: 'r'
  }



  # resources :users

  root               'static_pages#home'
  get 'help'      => 'static_pages#help'
  get 'about'     => 'static_pages#about'
  get 'contact'   => 'static_pages#contact'
  # get 'signup'    => 'users#new'
  # get 'login'     => 'sessions#new'
  # post 'login'    => 'sessions#create'
  # delete 'logout' => 'sessions#destroy'


  # below is the hierarchy: depts > professors > courses > reviews
  # once we thoroughly seed depts and professors, we can delete 
  resources :departments, only: [:index, :show, :new, :create]  # :new and :create
  resources :professors, only: [:index, :show, :new, :create]
  resources :courses

  resources :reviews, only: [:create, :destroy]

end
