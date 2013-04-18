CnnScraper::Application.routes.draw do
  resources :stories
  root to: "stories#index"
end
