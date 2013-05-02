class HemlockTenant < HemlockModel

  ################################################
  # class methods
  ################################################ 
  # broadcast instance methods
  def respond_to?(method_name, include_private = false)
    ["users", "tenants"].include? (method_name.to_s) || super
  end
  
end
