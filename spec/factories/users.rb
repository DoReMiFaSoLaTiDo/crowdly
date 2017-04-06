require 'ffaker'

FactoryGirl.define do
  factory :user do
    first_name { FFaker::Name.first_name }
    last_name { FFaker::Name.last_name }
    email { FFaker::Internet.email }
    password "12345678"
    password_confirmation "12345678"

    factory :invalid_user do
      email nil
    end
  end
end
