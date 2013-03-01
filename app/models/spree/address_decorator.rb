Spree::Address.class_eval do
  before_validation :generate_default_values
  def generate_default_values
    self.country = Spree::Country.find_by_iso("VN")
    self.zipcode = 70000
  end
  unvalidates = [:lastname, :city]
  _validators.reject!{ |key, value| unvalidates.include?(key) }
  _validate_callbacks.each do |callback|
    callback.raw_filter.attributes.reject! { |key| unvalidates.include?(key) } if callback.raw_filter.respond_to?(:attributes)
  end
end
