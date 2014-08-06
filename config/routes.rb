Blog::Application.routes.draw do

  resources :reports

  resources :pages

	get 'signup', to: 'users#new', as: 'signup'
	get 'login', to: 'sessions#new', as: 'login'
	get 'admin', to: 'sessions#new', as: 'login'
	get 'logout', to: 'sessions#destroy', as: 'logout'

  resources :users
  resources :sessions
	get 'cancel_registration', to: 'cancel_registration#new', as: 'cancel_registration'
  resources :cancel_registration

	get 'registrations/online', to: 'registrations#online', as: 'registrations/online'
  get 'about', to: 'pages#about', as: 'about'
	match 'reports/find_by_date', to: 'reports#find_by_date', as: 'reports/find_by_date'
	match 'all_registrations', to: 'registrations#all_registrations', as: 'all_registrations'
	match 'search', to: 'registrations#search', as: 'search'
	match 'registrations/find_by_class_date', to: 'registrations#find_by_class_date',
				as: 'registrations/find_by_class_date'
	match 'registrations/find_by_registration_date', to: 'registrations#find_by_registration_date',
				as: 'registrations/find_by_registration_date'
	match 'registrations/find_by_student_id', to: 'registrations#find_by_student_id',
				as: 'registrations/find_by_student_id'
	match 'registrations/find_by_name', to: 'registrations#find_by_name',
				as: 'registrations/find_by_name'

  resources :registrations do
		member do
			post 'toggle'
		end
	end

  resources :orientations do
		resources :registrations
	end

  root to: 'orientations#index'
	match '*path' => redirect('/')
end
