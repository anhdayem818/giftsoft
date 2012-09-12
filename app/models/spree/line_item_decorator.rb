Spree::LineItem.class_eval do
  def quantity_no_less_than_shipped
    already_shipped = order.shipments.reduce(0) { |acc,s| acc + s.inventory_units.select { |i| i.variant == variant }.count }
    unless quantity >= already_shipped
      errors.add(:quantity, I18n.t('validation.cannot_be_less_than_shipped_units'))
    end
  end
end
