Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #

  post "/slack_bots" => "slack_bot#create"
  post "/notification" => "slack_bot#notification"

end
