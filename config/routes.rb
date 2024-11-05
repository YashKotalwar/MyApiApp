# Rails.application.routes.draw do
#   devise_for :users,
#              defaults: { format: :json },
#              controllers: {
#                registrations: 'registrations',
#                sessions: 'sessions',
#                omniauth_callbacks: 'users/omniauth_callbacks'
#              }

#   devise_scope :user do
#     post 'login', to: 'sessions#create', defaults: { format: :json }
#     delete 'logout', to: 'sessions#destroy', defaults: { format: :json }

#     get 'users/auth/google_oauth2', to: 'users/omniauth_callbacks#passthru'
#     get 'users/auth/google_oauth2/callback', to: 'users/omniauth_callbacks#google_oauth2'
#     post 'users/auth/google_oauth2/callback', to: 'users/omniauth_callbacks#google_oauth2'
#   end

#   resources :recurring_subscriptions, only: [:create]
#   resources :subscriptions, only: [] do
#     post ':user_id/cancel', to: 'subscriptions#cancel', on: :collection
#   end
#   resources :plans, only: [:index, :create, :destroy] 
# end



# config/routes.rb
# Rails.application.routes.draw do
#   devise_for :users,
#              defaults: { format: :json },
#              controllers: {
#                registrations: 'registrations',
#                sessions: 'sessions',
#                omniauth_callbacks: 'users/omniauth_callbacks'
#              }

#   devise_scope :user do
#     post 'login', to: 'sessions#create', defaults: { format: :json }
#     delete 'logout', to: 'sessions#destroy', defaults: { format: :json }
#     get 'users/auth/google_oauth2', to: 'users/omniauth_callbacks#passthru', defaults: { format: :json }
#     get 'users/auth/google_oauth2/callback', to: 'users/omniauth_callbacks#google_oauth2', defaults: { format: :json }
#   end

#   resources :recurring_subscriptions, only: [:create], defaults: { format: :json }
#   resources :subscriptions, only: [], defaults: { format: :json } do
#     post ':user_id/cancel', to: 'subscriptions#cancel', on: :collection
#   end
#   resources :plans, only: [:index, :create, :destroy], defaults: { format: :json }
# end

# config/routes.rb
Rails.application.routes.draw do
  devise_for :users,
             controllers: {
               registrations: 'registrations',
               sessions: 'sessions',
               omniauth_callbacks: 'users/omniauth_callbacks'
             }

  devise_scope :user do
    post 'login', to: 'sessions#create', constraints: { format: 'json' }
    delete 'logout', to: 'sessions#destroy', constraints: { format: 'json' }

    get 'users/auth/google_oauth2', to: 'users/omniauth_callbacks#passthru', constraints: { format: 'json' }
    get 'users/auth/google_oauth2/callback', to: 'users/omniauth_callbacks#google_oauth2', constraints: { format: 'json' }
  end

  resources :recurring_subscriptions, only: [:create], constraints: { format: 'json' }
  resources :subscriptions, only: [], constraints: { format: 'json' } do
    post ':user_id/cancel', to: 'subscriptions#cancel', on: :collection, constraints: { format: 'json' }
  end
  resources :plans, only: [:index, :create, :destroy], constraints: { format: 'json' }

  resources :products, only: [:index, :create, :destroy], constraints: { format: 'json' }
end
