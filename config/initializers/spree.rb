# Configure Spree Preferences
# 
# Note: Initializing preferences available within the Admin will overwrite any changes that were made through the user interface when you restart.
#       If you would like users to be able to update a setting with the Admin it should NOT be set here.
#
# In order to initialize a setting do: 
# config.setting_name = 'new value'
Spree.config do |config|
  # Example:
  # Uncomment to override the default site name.
  config.site_name = "Mua mê ly"
  config.address_requires_state = false
  config.set(:default_locale => 'vn')
end

Spree.user_class = "Spree::User"

#if Spree::Config.instance
#  Spree::Config.set(:default_locale => 'de')
#end