$:.unshift(File.dirname(__FILE__))

require 'rubygems'
require 'config'
require 'membership'
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
    
    def transact membership_type = "BASIC"
      
      # this part is messy...
      unless %w{ BASIC PREMIUM TRIAL }.include? membership_type.upcase
        return false
      end
      membership_options = {}
      case membership_type.upcase
      when "BASIC"
        membership_options = Membership::BASIC
      when "PREMIUM"
        membership_options = Membership::PREMIUM
      when "TRIAL"
        membership_options = Membership::TRIAL
      end
      
      frontend = init_frontend
      frontend.tax_table_factory = TaxTableFactory.new
      checkout_command = frontend.create_checkout_command
      cart = checkout_command.shopping_cart
      cart.create_item do |item|
        membership_options.each do |key, value|
          item.method("#{key}=").call value
        end
      end
      response = checkout_command.send_to_google_checkout
      puts response
    end
    
  end
end
