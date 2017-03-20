require 'flipper'
require "flipper-api"
require "flipper-ui"

Soloflipper::Application.routes.draw do
  get 'flipper_wrapper/:feature/isEnabledFor/:user', to: 'flipper_wrapper#show'

  get 'welcome/index'

  mount Flipper::Api.app(Rails.application.config.flipper) => '/flipper/api'
  mount Flipper::UI.app(Rails.application.config.flipper) => '/flipper'
end
