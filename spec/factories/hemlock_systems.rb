# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :hemlock_system do
    data_type "MyString"
    endpoint "MyText"
    hostname "MyString"
    poc_name "MyString"
    port 1
    description "MyText"
    updated_data "MyString"
    remote_uri "MyText"
    name "MyString"
    poc_email "MyString"
    remote 1
  end
end
