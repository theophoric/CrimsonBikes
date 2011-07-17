require 'rubygems'
require 'google4r/checkout'

module CbCheckout
  class TaxTableFactory
    def effective_tax_tables_at(time)
      table1 = Google4R::Checkout::TaxTable.new(false)
      table1.name = "Default Tax Table"
      table1.create_rule do |rule|
        rule.area = Google4R::Checkout::UsStateArea.new("MA")
        rule.rate = 0.00
      end
      [ table1 ]
    end
  end
end