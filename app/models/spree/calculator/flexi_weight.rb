require_dependency 'spree/calculator'

module Spree
  class Calculator::FlexiWeight < Calculator
    preference :weight_list, :string
    preference :price_list, :string
    
    attr_accessible :preferred_weight_list, :preferred_price_list

    def self.description
      "Flexi Weight"
    end

    def compute(order)
      prices = self.preferred_price_list.nil? ? [] : self.preferred_price_list.split(',')
      weights = self.preferred_weight_list.nil? ? [] : self.preferred_weight_list.split(',')

      weight_prices = weights.to_enum(:each_with_index).map do |weight, i|
        {:weight => weight.to_f, :price => prices[i].to_f}
      end

      total_weight = 0
      order.line_items.each do |item|
        total_weight += item.quantity * (item.variant.weight || 10)
      end

      shipping_price = 0
      start_of_current_range = 0
      weight_prices.each do |weight_price|
        if total_weight >= start_of_current_range && total_weight < weight_price[:weight]
          shipping_price = weight_price[:price]
        end
        start_of_current_range = weight_price[:weight]
      end

      return shipping_price
    end
  end
end
