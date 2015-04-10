GogogibbonTools::Engine.routes.draw do

  resources :mailchimp_subscribers do
    collection do
      get 'init'
      get 'details'
      post 'batch'
      post 'unsubscribe'
    end
  end

  root to: 'mailchimp_subscribers#index'

end
