# Rails.application.routes.draw do
#   namespace :api do
#     namespace :v1 do
#       get "articles/index"
#     end
#   end
#   # mount_devise_token_auth_for "User", at: "auth"
#   # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
#   namespace "api" do
#     namespace "v1" do
#       mount_devise_token_auth_for "User", at: "auth"
#       resources :articles
#     end
#   end
# end

Rails.application.routes.draw do
  root to: "home#index"

  namespace :api do
    namespace :v1 do
      mount_devise_token_auth_for "User", at: "auth", controllers: {
        registrations: "api/v1/auth/registrations"
      }
      resources :articles
    end
  end
end
