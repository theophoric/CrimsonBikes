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
    
    option  :merchant_id  , :default => "618974739863729"
    option  :merchant_key , :default => "4zkYk_TKGOxSsalUuKTZAw"
    option  :use_sandbox      , :default => true
  end
end