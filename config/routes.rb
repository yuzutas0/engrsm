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

    # tale
    get    '/mypage',                  to: 'tales#index',  as: 'tales'
    post   '/tales',                   to: 'tales#create', as: 'create_tale'
    get    '/tales/new',               to: 'tales#new',    as: 'new_tale'
    get    '/tales',                   to: 'tales#new'
    get    '/tales/:view_number/edit', to: 'tales#edit',   as: 'edit_tale'
    get    '/tales/:view_number',      to: 'tales#show',   as: 'tale'
    patch  '/tales/:view_number',      to: 'tales#update', as: 'update_tale'
    put    '/tales/:view_number',      to: 'tales#update'
    delete '/tales/:view_number',      to: 'tales#destroy'

    # comment
    post   '/comments', to: 'comments#create', as: 'create_comment'
    patch  '/comments', to: 'comments#update', as: 'update_comment'
    put    '/comments', to: 'comments#update'
    delete '/comments', to: 'comments#destroy'

    # tag
    get    '/tags',              to: 'tags#index',  as: 'tags'
    patch  '/tags/:view_number', to: 'tags#update', as: 'tag'
    put    '/tags/:view_number', to: 'tags#update'
    delete '/tags/:view_number', to: 'tags#destroy'

    # search condition
    get    '/searches',                       to: 'search_conditions#index',  as: 'search_conditions'
    patch  '/search_conditions/:view_number', to: 'search_conditions#update', as: 'search_condition'
    put    '/search_conditions/:view_number', to: 'search_conditions#update'
    delete '/search_conditions/:view_number', to: 'search_conditions#update'

    # backup
    post '/backup', to: 'backups#download', as: 'backup'

    # no route error
    get    '*all', to: 'application#routing_error'
    post   '*all', to: 'application#routing_error'
    patch  '*all', to: 'application#routing_error'
    put    '*all', to: 'application#routing_error'
    delete '*all', to: 'application#routing_error'
  end
end
