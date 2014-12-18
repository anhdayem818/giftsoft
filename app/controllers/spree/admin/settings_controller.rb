module Spree
  module Admin
    class SettingsController < ResourceController

      def index
        @setting = Spree::Setting.first
      end
    end
  end
end