$:.unshift(File.dirname(__FILE__))

require 'rubygems'
require 'config'
require 'membership'
require 'connect'
require 'google4r/checkout'

module CbCheckout
  class << self
    def configure
      config = CbCheckout::Config
      block_given? ? yield(config) : config
    end
    alias :config :configure
  end
end
