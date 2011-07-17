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
    
    def transact membership_type = "BASIC", user_id
      request_response = {:status => "fail", :redirect_url => "#{Rails.root}/"}
      # this part is messy...
      unless %w{ BASIC PREMIUM TRIAL }.include? membership_type.upcase
        return request_response
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
      puts "membership_options=#{membership_options}"
      frontend = init_frontend
      puts frontend
      frontend.tax_table_factory = TaxTableFactory.new
      checkout_command = frontend.create_checkout_command
      checkout_command.private_data= {:user_id => user_id}
      cart = checkout_command.shopping_cart
      cart.create_item do |item|
        membership_options.each do |key, value|
          item.method("#{key}=").call value
        end
      end
      puts checkout_command.to_xml
      response = checkout_command.send_to_google_checkout
      request_response = {:status => "sent", :redirect_url => response.redirect_url}
    end
    
    def mypost
      # Use your own merchant ID and Key, set use_sandbox to false for production
      configuration2 = { :merchant_id => '618974739863729', :merchant_key => '4zkYk_TKGOxSsalUuKTZAw', :use_sandbox => true }
      frontend = Google4R::Checkout::Frontend.new(configuration2)

        # Create a new checkout command (to place an order)
        cmd = frontend.create_checkout_command

        # Add an item to the command's shopping cart
        cmd.shopping_cart.create_item do |item|
          item.name = "2-liter bottle of Diet Pepsi"
          item.quantity = 100
          item.unit_price = Money.new(1.99, "USD")
        end

        # Send the command to Google and capture the HTTP response
        response = cmd.send_to_google_checkout

        # Redirect the user to Google Checkout to complete the transaction
        puts response.redirect_url
    end
    
  end
end
