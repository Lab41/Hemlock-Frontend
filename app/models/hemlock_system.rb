class HemlockSystem < HemlockModel
# class variables
attr_accessor :data_type, :description, :endpoint, :hostname, :port, :remote_uri, :poc_name, :poc_email, :remote, :updated_data

  ################################################
  # class methods
  ################################################  
  def initialize(args=nil)
    super
    self.port = self.port.to_i unless self.port.nil?
    self.remote = self.remote.to_i unless self.remote.nil?
  end
   
   
  ################################################
  # class methods
  ################################################ 
  # broadcast instance methods
  def respond_to?(method_name, include_private = false)
    ["tenants"].include? (method_name.to_s) || super
  end
end
