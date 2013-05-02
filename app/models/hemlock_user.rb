class HemlockUser < HemlockModel
  # class variables
  attr_accessor :username, :email
  
  
  ################################################
  # class methods
  ################################################ 
  # broadcast instance methods
  def respond_to?(method_name, include_private = false)
    ["tenants", "roles"].include? (method_name.to_s) || super
  end
end
