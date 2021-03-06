$:.unshift(File.dirname(__FILE__))

require 'rubygems'
require 'config'
require 'membership_type'
require 'connect'
require 'tax_table_factory'
require 'google4r/checkout'

module CbCheckout
  class << self
    def configure
      config = CbCheckout::Config
      block_given? ? yield(config) : config
    end
    alias :config :configure
    
    def init_frontend
      Google4R::Checkout::Frontend.new(config.settings)
    end
    
    def transact membership_type = "HALF", user_id = nil
      request_response = {:status => "fail", :redirect_url => "#{Rails.root}/"}
      # this part is messy...
      unless %w{ HALF FULL TRIAL }.include? membership_type.upcase
        return request_response
      end
      membership_options = {}
      case membership_type.upcase
      when "HALF"
        membership_options = MembershipType::HALF
      when "FULL"
        membership_options = MembershipType::FULL
      when "TRIAL"
        membership_options = MembershipType::TRIAL
      end
      @frontend = init_frontend
      @frontend.tax_table_factory = TaxTableFactory.new
      checkout_command = @frontend.create_checkout_command
      cart = checkout_command.shopping_cart
      cart.private_data= {:user_id => user_id}
      cart.create_item do |item|
        membership_options.each do |key, value|
          item.method("#{key}=").call value
        end
      end
      response = checkout_command.send_to_google_checkout
      request_response = {:status => "sent", :redirect_url => response.redirect_url}
      return request_response
    end
  end
end
