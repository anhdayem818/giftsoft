Spree::Payment.class_eval do
  state_machine :initial => 'checkout' do
    after_transition :to => 'completed',  :do => :add_point_to_user
  end
  def add_point_to_user
    point = self.order.user.point + self.amount/10000
    self.order.user.update_attribute("point", point)
  end
end