module CbCheckout
  module Config
    extend self
    attr_accessor :settings
    
    @settings = {}
  
    def option( name, options = {})
      define_method(name) do
        settings.has_key?(name) ? settings[name] : options[:deault]
      end
      define_method("#{name}=") { |value| settings[name] = value }
      define_method("#{name}?") { send(name) }
    end
    
    option  :merchant_id  , :default => "123456789"
    option  :merchant_key , :default => "test_key"
    option  :use_sandbox      , :default => true
  end
end