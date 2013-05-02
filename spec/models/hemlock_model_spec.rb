require 'spec_helper'

describe HemlockModel do

  before(:each) do
    @attr = {
      :id => 1,
      :uuid => "abcd",
      :name => "name",
      :created => Time.today
    }
  end  
  
  it "should create a new instance given a valid attribute" do
    HemlockModel.create!(@attr)
  end 
  
  it "should require an id" do
    no_id = HemlockModel.new(@attr.merge(:id => ""))
    no_id.should_not be_valid
  end 
  
  it "should require a uuid" do
    no_uuid = HemlockModel.new(@attr.merge(:uuid => ""))
    no_uuid.should_not be_valid
  end   
  
  
end
