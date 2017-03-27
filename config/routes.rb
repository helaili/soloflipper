require 'flipper'
require "flipper-api"
require "flipper-ui"

Soloflipper::Application.routes.draw do
  get 'welcome/index'

  mount Flipper::Api.app(Rails.application.config.flipper) => '/flipper/api'
  mount Flipper::UI.app(Rails.application.config.flipper) => '/flipper'
end
