Clio::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # less logging - turn on/off as needed for local development
  config.log_level = :warn

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true


  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  config.assets.compress = false
  config.assets.debug = false

  config.assets.digest = false

  # Don't care if the mailer can't send
  config.action_mailer.delivery_method = :test
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log
  config.active_record.auto_explain_threshold_in_seconds = 0.5
  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # in development, rails should hand off emails to localhost's sendmail
  config.action_mailer.delivery_method = :sendmail
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true

  # BlacklightUnapi - quiet the extensive log entries:
  # DEPRECATION WARNING: Passing a template handler in the template 
  # name is deprecated. You can simply remove the handler name or 
  # pass render :handlers => [:builder] instead.
  #  
  ActiveSupport::Deprecation.silenced = true

end

