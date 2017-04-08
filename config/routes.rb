# frozen_string_literal: true
Rails.application.routes.draw do
  # locale
  scope '(:locale)', locale: /en|ja/ do
    # home
    root 'home#index'
    get  'home/index'

    # static pages
    get 'terms',   to: 'home#terms',   as: 'terms'
    get 'privacy', to: 'home#privacy', as: 'privacy'
    get 'contact', to: 'home#contact', as: 'contact'
    get 'support', to: 'home#support', as: 'support'
    get 'about',   to: 'home#about',   as: 'about'

    # user
    devise_for :users,
               path_names: {
                 sign_in: 'login',
                 sign_out: 'logout',
                 sign_up: 'signup'
               },
               controllers: {
                 registrations: 'registrations',
                 sessions: 'sessions'
               }

    # post
    get    '/mypage',         to: 'posts#index',  as: 'posts'
    post   '/posts',          to: 'posts#create', as: 'create_post'
    get    '/posts/new',      to: 'posts#new',    as: 'new_post'
    get    '/posts',          to: 'posts#new'
    get    '/posts/:id/edit', to: 'posts#edit',   as: 'edit_post'
    get    '/posts/:id',      to: 'posts#show',   as: 'post'
    patch  '/posts/:id',      to: 'posts#update', as: 'update_post'
    put    '/posts/:id',      to: 'posts#update'
    delete '/posts/:id',      to: 'posts#destroy'

    # comment
    post   '/comments',     to: 'comments#create', as: 'create_comment'
    patch  '/comments/:id', to: 'comments#update', as: 'update_comment'
    put    '/comments/:id', to: 'comments#update'
    delete '/comments/:id', to: 'comments#destroy', as: 'comment'

    # tag
    get    '/tags',     to: 'tags#index',  as: 'tags'
    patch  '/tags/:id', to: 'tags#update', as: 'tag'
    put    '/tags/:id', to: 'tags#update'
    delete '/tags/:id', to: 'tags#destroy'

    # search condition
    get    '/searches',              to: 'search_conditions#index',  as: 'search_conditions'
    patch  '/search_conditions/:id', to: 'search_conditions#update', as: 'search_condition'
    put    '/search_conditions/:id', to: 'search_conditions#update'
    delete '/search_conditions/:id', to: 'search_conditions#update'

    # backup
    post '/backup', to: 'backups#download', as: 'backup'

    # contact
    post '/contact', to: 'contacts#create', as: 'create_contact'

    # no route error
    get    '*all', to: 'application#routing_error'
    post   '*all', to: 'application#routing_error'
    patch  '*all', to: 'application#routing_error'
    put    '*all', to: 'application#routing_error'
    delete '*all', to: 'application#routing_error'
  end
end
