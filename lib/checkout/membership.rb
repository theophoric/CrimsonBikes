require 'google4r/checkout'
module CbCheckout
  module Membership    
    BASIC       = {:name => "Basic Crimson Bikes Membership", :description => "Enables you to checkout up to 1 bike at a time for a duration of up to 5 hours", :unit_price => Money.new(0, "USD"), :quantity => 1}
    PREMIUM     = {:name => "Premium Crimson Bikes Membership", :description => "Enables you to checkout up to 1 bike at a time for a duration of up to 5 hours", :unit_price => Money.new(0, "USD"), :quantity => 1}
    TRIAL       = {:name => "Trial Crimson Bikes Membership", :description => "Enables you to checkout up to 1 bike at a time for a duration of up to 5 hours", :unit_price => Money.new(0, "USD"), :quantity => 1}
    
    # def get_option option = "BASIC"
    #   case option.upcase
    #   when "BASIC"
    #     BASIC
    #   when "PREMIUM"
    #     PREMIUM
    #   when "TRIAL"
    #     TRIAL
    #   end
    # end
  end
end