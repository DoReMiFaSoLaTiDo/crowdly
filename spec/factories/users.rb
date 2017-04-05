require 'ffaker'

FactoryGirl.define do
  factory :user do
    first_name { FFaker::Name.first_name }
    last_name { FFaker::Name.last_name }
    email { FFaker::Internet.email }
    password "WxryuTest"
    password_confirmation "WxryuTest"

    factory :invalid_user do
      email nil
    end
  end
end
