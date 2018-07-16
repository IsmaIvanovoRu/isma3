Isma::Application.routes.draw do

  get "sitemaps/sitemap"
  
  resources :comments
  
  controller :sveden do
    get 'sveden' => :index
  end
  get 'sveden/common'
  get 'sveden/struct'
  get 'sveden/document'
  get 'sveden/education'
  get 'sveden/eduStandarts'
  get 'sveden/employees'
  get 'sveden/objects'
  get 'sveden/grants'
  get 'sveden/paid_edu'
  get 'sveden/budget'
  get 'sveden/vacant'
  controller :abitur do
    get 'abitur' => :index
    get 'Abitur' => :index
  end
  
  devise_for :users, :controllers => { :registrations => "registrations" }
  
  controller :search do
    get 'search' => :index
  end
  
  controller :blind do
    get :common
    get :special
  end
  
  resources :users do
    resource :profile do
      member do
        put :published_toggle
      end
    end
    collection do
      post :import
    end
  end
  
  resources :articles do
    resources :comments do
      member do
	put :published_toggle
      end
    end
    member do
      put :published_toggle
      put :up
      put :cleanup_message
    end
  end
  resources :attachments
  resources :details  
  controller :archives do
    get 'archives' => :index
    get :feed
  end

  controller :contacts do
    get 'contacts' => :index
  end
  
  
  resources :groups do
    member do
      get :add_to
      delete :remove_from
    end
  end
  
  resources :divisions do 
    resources :posts do
      member do
        get :add_subject
        delete :remove_subject
      end
    end
    collection do
      post :import
    end
  end
  
  resources :menus
  
  resources :feedbacks do 
    member do
      put :published_toggle
      put :up
    end
  end
  
  resources :educational_standarts
  
  resources :educational_programs
  
  resources :educational_program_numbers do
    collection do
      post :import
    end
  end
  
  resources :educational_program_priems do
    collection do
      post :import
    end
  end
  
  resources :educational_program_vacants do
    collection do
      post :import
    end
  end
  
  resources :academic_plans
  
  resources :academic_schedules
  
  resources :practices
  
  resources :methodological_supports
  
  resources :accreditations
  
  resources :subjects
  
  resources :classrooms do
    collection do
      post :import
    end
  end

  resources :achievements do
    collection do
      get :report
    end
    member do
      put :published_toggle
    end
  end

  resources :achievement_categories

  resources :achievement_results

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'
  
  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase
  get 'attachments/:id/minify_img' => 'attachments#minify_img', :as => :minify_img
  get 'attachments/:id/inline' => 'attachments#inline', :as => :inline
  
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
