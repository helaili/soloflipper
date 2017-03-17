require 'flipper'

require "flipper-api"
require "flipper-ui"
require "flipper/adapters/pstore"

Flipper.register(:admins) { |actor|
  actor.respond_to?(:admin?) && actor.admin?
}

Flipper.register(:early_access) { |actor|
  actor.respond_to?(:early?) && actor.early?
}

# Setup logging of flipper calls.
$logger = Logger.new(STDOUT)
require "active_support/notifications"
require "flipper/instrumentation/log_subscriber"
Flipper::Instrumentation::LogSubscriber.logger = $logger

adapter = Flipper::Adapters::PStore.new
flipper = Flipper.new(adapter, instrumenter: ActiveSupport::Notifications)

Soloflipper::Application.routes.draw do
  mount Flipper::Api.app(flipper) => '/flipper/api'
  mount Flipper::UI.app(flipper) => '/flipper'
end
