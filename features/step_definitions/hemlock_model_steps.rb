### UTILITY METHODS ###
def noisy_tests
  true
end

def all_models
  [:tenant, :system, :user, :role]
end

def class_methods
  [:all, :first, :find]
end

def instance_methods
  all_models.collect { |m| m.to_s.pluralize.to_sym }
end

def retrieve_model(model_name="model")
  puts "retrieving #{model_name}" if noisy_tests
  instance_variable_get("@hemlock_#{model_name}")
end

def create_model(model_name="model")
  puts "creating #{model_name}" if noisy_tests
  instance_variable_set("@hemlock_#{model_name}", FactoryGirl.create("hemlock_#{model_name}"))
end

def create_model_empty(model_name="model")
  puts "creating empty #{model_name}" if noisy_tests
  instance_variable_set("@hemlock_#{model_name}", FactoryGirl.create("hemlock_#{model_name}", {}))
end

def create_model_invalid(model_name="model")
  puts "creating invalid #{model_name}" if noisy_tests
  lambda { FactoryGirl.create("hemlock_#{model_name}", :invalid_attribute => 15) }.should raise_error  
end

def query_api_for_list_results(model_instance, api_action="all", api_args=nil)
  if model_instance.class.respond_to? api_action.to_sym
    puts "#{model_instance.class.to_s} querying for #{api_action}" if noisy_tests
    instance_variable_set("@results_#{model_instance.class.to_s.downcase}", model_instance.class.send(api_action))
  end
end

def query_api_for_sublist_results(model_instance, instance_method)
  if model_instance.respond_to? instance_method.to_sym
    query_api_for_list_results(model_instance, "first")
    model_instance = instance_variable_get("@results_#{model_instance.class.to_s.downcase}") 
    puts "#{model_instance.class.to_s} with uuid #{model_instance.uuid} querying for #{instance_method}" if noisy_tests
    instance_variable_set("@results_#{model_instance.class.to_s.downcase}", model_instance.send(instance_method))
  end
end

### GIVEN ###
Given /^all models are created without arguments/ do
  all_models.each do |model_name|
    create_model_empty(model_name)
  end
end

Given /^the (.*?)model is created without arguments$/ do |model_name|
  model_name = "model" if model_name.empty?
  create_model_empty(model_name)
end

Given /^all models are created with invalid arguments/ do
  all_models.each do |model_name|
    create_model_invalid(model_name)
  end
end

Given /^the (.*?)model is created with invalid arguments$/ do |model_name|
  model_name = "model" if model_name.empty?
  create_model_invalid(model_name)
end

Given /^all models exist/ do
  all_models.each do |model_name|
    create_model(model_name)
  end
end

Given /^the (.*?)model exists$/ do |model_name|
  model_name = "model" if model_name.empty?
  puts model_name.strip
  create_model(model_name)
end

### WHEN ###
When /^all models query the API for list results$/ do
  all_models.each do |model_name|
    model_instance = retrieve_model(model_name)
    query_api_for_list_results(model_instance, "all")
  end  
end

When /^all models query the API for a single result$/ do
  all_models.each do |model_name|
    model_instance = retrieve_model(model_name)
    query_api_for_list_results(model_instance, "first")
  end  
end

When /^all models query the API for associated sublist results$/ do
  all_models.each do |model_name|
    model_instance = retrieve_model(model_name)
    instance_methods.each do |method|
      query_api_for_sublist_results(model_instance, method)
    end
  end  
end

### THEN ###
Then /^all models should exist$/ do
  all_models.each do |model_name|
    model_instance = retrieve_model(model_name)
    model_instance.should_not be_nil  
  end
end

Then /^the (.*?)model should exist$/ do |model_name|
  model_name = "model" if model_name.empty?
  model_instance = retrieve_model(model_name)
  model_instance.should_not be_nil
end

Then /^all models should not exist$/ do
  all_models.each do |model_name|
    model_instance = retrieve_model(model_name)
    model_instance.should be_nil  
  end
end


Then /^list API calls should return valid results$/ do
  all_models.each do |model_name|
    model_instance = retrieve_model(model_name)
    results = instance_variable_get("@results_#{model_instance.class.to_s.downcase}") 
    results.first.should be_valid
  end
end

Then /^single API calls should return valid results$/ do
  all_models.each do |model_name|
    model_instance = retrieve_model(model_name)
    result = instance_variable_get("@results_#{model_instance.class.to_s.downcase}") 
    result.should be_valid
  end
end

Then /^the (.*?)model should not exist$/ do |model_name|
  model_name = "model" if model_name.empty?
  model_instance = retrieve_model(model_name)
  model_instance.should be_nil
end
