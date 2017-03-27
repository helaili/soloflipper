require 'flipper'

require "flipper-api"
require "flipper-ui"
require "flipper/adapters/pstore"
require "active_support/notifications"
require "flipper/instrumentation/log_subscriber"

puts "Initializing flipper"

Flipper.register(:admins) { |actor|
  actor.respond_to?(:admin?) && actor.admin?
}

Flipper.register(:early_access) { |actor|
  actor.respond_to?(:early?) && actor.early?
}

Flipper.register(:marketing) { |actor|
  actor.respond_to?(:marketing?) && actor.marketing?
}

# Setup logging of flipper calls.
$logger = Logger.new(STDOUT)
Flipper::Instrumentation::LogSubscriber.logger = $logger

adapter = Flipper::Adapters::PStore.new
flipper = Flipper.new(adapter, instrumenter: ActiveSupport::Notifications)
Rails.application.config.flipper = flipper
Rails.application.config.middleware.use "FlipperEnabledMiddleware", flipper
