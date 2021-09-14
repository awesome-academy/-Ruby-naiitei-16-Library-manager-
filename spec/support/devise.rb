require_relative "./controller_macro"
RSpec.configure do |config|
  config.include Devise::TestHelpers, :type => :controller
  config.extend ControllerMacro, :type => :controller
end
