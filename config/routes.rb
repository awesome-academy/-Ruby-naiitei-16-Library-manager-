Rails.application.routes.draw do
  # devise_for :users
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"
    get "/home", to: "static_pages#home"
    get "/help", to: "static_pages#help"

    get "/signup", to: "users#new"
    resources :users do
      member do
        resources :following, only: :index
        resources :follower, only: :index
      end
    end
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"

    get "/admin" => "admin#index"
    get "/user/requests", to: "requests#index"
    get "/user/categories", to: "categories#index"
    get "/user/categories/:id", to: "categories#show", as: "user_categories_show"

    get "/user/books", to: "books#index"
    get "/user/books/:id", to: "books#show", as: "user_books_show"

    scope :admin do
      resources :books
      resources :categories
      get "/return_book_list", to: "requests#edit"
      patch "/return_book", to: "requests#update"
    end

    resources :books do
      resources :reviews
    end
    resources :categories
    resources :relationships, only: %i(create destroy)

    resources :books do
      resources :requests
    end
    resources :requests, only: :index
    get "/not_returned", to: "requests#not_returned"
    get "/success", to: "requests#success"
  end
end
