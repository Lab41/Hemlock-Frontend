class HemlockRole < HemlockModel


  ################################################
  # class methods
  ################################################  
  def initialize(args=nil)
    super
  end


  ################################################
  # class methods
  ################################################ 
  # broadcast instance methods
  def respond_to?(method_name, include_private = false)
    ["users"].include? (method_name.to_s) || super
  end
  
end
