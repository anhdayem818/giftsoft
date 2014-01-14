module Spree
  Order.class_eval do
    attr_accessible :coupon
    #has_many :line_items, :dependent => :destroy, :class_name => "Spree::LineItem"
    def add_variant(variant, quantity = 1)
      current_item = find_line_item_by_variant(variant)
      if current_item
        current_item.quantity += quantity
        if(current_item.quantity > variant.on_hand)
          return nil
        end
        current_item.save
      else
        current_item = Spree::LineItem.new(:quantity => quantity)
        current_item.variant = variant
        current_item.price   = variant.price
        self.line_items << current_item
      end

      self.reload
      current_item
    end

    def validate_total
      self.item_total >= 200000
    end
    def validate_items
      self.line_items.includes(:variant).each do |item|
        if(item.quantity > item.variant.on_hand)
          if item.variant.on_hand > 0
            item.quantity = item.variant.on_hand
          else
            self.line_items.delete(item)
          end
          self.reload
        end
      end
    end

    def remove_item(id)
      self.line_items.destroy(id)
      self.reload
    end

    def load_address
      if self.user.present?
        saved_order = self.user.orders.complete.where("bill_address_id is not null").first
        if saved_order.present?
          self.ship_address = self.bill_address = saved_order.bill_address 
          self.save
        end
      end
    end

    def self.get_report(start_date, end_date)
      self.where(:updated_at => start_date..end_date, :payment_state => 'paid').where("total > 0")
        .select("sum(total) as total, DATE(paid_at) as paid_at")
        .group("DATE(paid_at)")
    end

    def item_count
      line_items.sum(:quantity)
    end

    def update_payment_state

      #line_item are empty when user empties cart
      if self.line_items.empty? || round_money(payment_total) < round_money(total)
        self.payment_state = 'balance_due'
        self.payment_state = 'failed' if payments.present? and payments.last.state == 'failed'
      else
        self.payment_state = 'paid'
        self.paid_at = Time.now()
      end

      if old_payment_state = self.changed_attributes['payment_state']
        self.state_changes.create({
          :previous_state => old_payment_state,
          :next_state     => self.payment_state,
          :name           => 'payment',
          :user_id        => (User.respond_to?(:current) && User.current && User.current.id) || self.user_id
        }, :without_protection => true)
      end
    end

    def update!
      update_totals
      update_payment_state

      # give each of the shipments a chance to update themselves
      shipments.each { |shipment| shipment.update!(self) }#(&:update!)
      update_shipment_state
      update_adjustments
      # update totals a second time in case updated adjustments have an effect on the total
      update_totals

      update_attributes_without_callbacks({
        :payment_state => payment_state,
        :paid_at => paid_at,
        :shipment_state => shipment_state,
        :item_total => item_total,
        :adjustment_total => adjustment_total,
        :payment_total => payment_total,
        :total => total
      })

      #ensure checkout payment always matches order total
      if payment and payment.checkout? and payment.amount != total
        payment.update_attributes_without_callbacks(:amount => total)
      end

      update_hooks.each { |hook| self.send hook }
    end
  end
end