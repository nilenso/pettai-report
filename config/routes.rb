PettaiReport::Application.routes.draw do
  resource :report, :only => :show
end
