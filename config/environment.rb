# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Relayfan::Application.initialize!

if Rails.env.development?
	Rails.logger = Le.new('e8ef33a4-44ed-44db-8572-c444473640c9', true)
else
	Rails.logger = Le.new('e8ef33a4-44ed-44db-8572-c444473640c9')
end

Rails.logger.info("information message")
Rails.logger.warn("warning message")
Rails.logger.debug("debug message")
