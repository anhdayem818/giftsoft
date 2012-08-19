Spree::Address.class_eval do
  before_validation :generate_default_values
  def generate_default_values
    self.country = Spree::Country.find_by_iso("VN")
    self.lastname = "NA"
    self.zipcode = 70000
  end
end
