# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    name 'Test User'
    email 'example@example.com'
    password 'MyPassword'
    password_confirmation 'MyPassword'
    # required if the Devise Confirmable module is used
    # confirmed_at Time.now
  end
end
