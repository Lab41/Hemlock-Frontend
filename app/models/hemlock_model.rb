class HemlockModel < TablelessModel
  attr_accessor :id, :uuid, :name, :created
  validates_presence_of :id, :uuid
  
  ################################################
  # class methods
  ################################################  
  def self.method_missing(method_name, *arguments, &block)
    allowed = [:all, :first, :find]
    if allowed.include? method_name
    
      # prepare
      get_hemlock_downloader
      model_type = self.inspect.to_s.gsub(/^hemlock/i,"")

      # query API    
      case method_name
      when :all
        api_results = @hemlock_api.call_api "/list/#{model_type.downcase.pluralize}"
        api_to_model_array(api_results, self.inspect.constantize)
            
      when :first
        api_results = @hemlock_api.call_api "/list/#{model_type.downcase.pluralize}"
        api_to_model(api_results, self.inspect.constantize)
        
      when :find
        result = @hemlock_api.call_api "/get/#{model_type.downcase}/#{arguments.first}"
        self.new result.symbolize_keys
        
      else
        super      
      end

    # otherwise call standard 
    else
      super
    end
    
  end
  
  # broadcast class methods
  def self.respond_to?(method_name, include_private = false)
    [:all, :first, :find].include? method_name || super
  end
  
  
  # build array of results
  def self.api_to_model_array(api_results, klass)
    result = []

    begin
      # list of results in form of [uuid1, uuid2, ....]
      if api_results.is_a? Array
        api_results.each do |uuid|
          result << klass.find(uuid)    
        end
        
      # list of results in form of {propert => uuid1, property => uuid2, ....}
      elsif api_results.is_a? Hash
        api_results.each do |property, uuid|
          result << klass.find(uuid)    
        end
      
      # generic catch
      else
        raise "Invalid API format: \n#{api_results}"      
      end
      
      #return
      result
    
    rescue Exception => e
      puts "#{__method__}: #{e.message}"
      nil
    end
  end
    
  # build array of results
  def self.api_to_model(api_results, klass)
    result = nil

    begin
      # list of results in form of [uuid1, uuid2, ....]
      if api_results.is_a? Array
        result = klass.find(api_results.first)
        
      # list of results in form of {propert => uuid1, property => uuid2, ....}
      elsif api_results.is_a? Hash
        key, value = api_results.first
        result = klass.find(value)
      
      # generic catch
      else
        raise "Invalid API format: \n#{api_results}"      
      end
      
      # return
      result
    
    rescue Exception => e
      puts "#{__method__}: #{e.message}"
      nil
    end
  end
  
  ################################################
  # instance methods
  ################################################    
  def initialize(args=nil)
    super
    get_hemlock_downloader  
    
    # format variables    
    self.id = self.id.to_i unless self.id.nil?
    self.created = Time.parse(self.created) unless self.created.nil?
  end
  
  # override the save method to prevent exceptions
  def save( validate = true )
    validate ? valid? : true
  end
  
  # override the save method to prevent exceptions
  def save!( validate = true )
    validate ? valid? : true
  end
  
  # enable instances to call one of the specified methods
  def method_missing(method_name, *arguments, &block)
    allowed = [:tenants, :systems, :users, :roles]
    if allowed.include? method_name
    
      # query API
      model_type = self.class.to_s.gsub(/^hemlock/i,"")
      api_results = @hemlock_api.call_api "/list/#{model_type.downcase}/#{method_name}/#{self.uuid}"
      
      # build array of results
      self.class.api_to_model_array(api_results, "Hemlock#{method_name.to_s.singularize.capitalize}".constantize)
      
    else
      super
    end 
  end

  # broadcast instance methods in child classes
  def respond_to?(method_name, include_private = false)
    super
  end
  
private
  def self.get_hemlock_downloader
    @hemlock_api ||= HemlockDownloader.new
  end
  
  def get_hemlock_downloader
    @hemlock_api ||= HemlockDownloader.new
  end
 
end
