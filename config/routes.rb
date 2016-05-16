Rails.application.routes.draw do
  get 'authentication/index'

  devise_for :users, :controllers => {
                       :sessions => "users/sessions",
                       :confirmations => "users/confirmations",
                       :passwords => "users/passwords",
                       :registrations => "users/registrations",
                       :omniauth_callbacks => "users/omniauth_callbacks",
                       #      :confirmations => "users/confirmations"
                   }

  devise_scope :user do
    get 'new_sign_up', :to => "users/registrations#new_sign_up"
    get 'mosque_sign_in', :to => "users/sessions#mosque_sign_in"
    get 'admin_sign_in', :to => "users/sessions#admin_sign_in"
  end
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'admin/admins#dashboard'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end
  #admin namespace
  namespace :admin do
    resources :admins do
      collection do
        get 'dashboard'
      end
    end

    resources :parents do
      collection do
      end
    end

    resources :children do
      collection do
      end
    end

    resources :mosques do
      collection do
      end
    end
  end

  #mosque namespace
  namespace :mosque do
    resources :mosques do
      collection do
      end
    end
  end

  #parent namespace
  namespace :parent do
    resources :parents do
      collection do
        get 'check_email'
        patch 'update_profile'
        post 'update_password'
        post 'payment_info'
      end
    end
  end

  get 'parent/family', :to => "parent/parents#family"
  get 'parent/profile', :to => "parent/parents#profile"

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
