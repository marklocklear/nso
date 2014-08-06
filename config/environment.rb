# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Blog::Application.initialize!

Date::DATE_FORMATS[:default] = '%B %-d %Y'
