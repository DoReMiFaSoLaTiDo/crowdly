require 'ffaker'

FactoryGirl.define do
  factory :post do
    user
    title FFaker::Lorem.word
    body FFaker::HipsterIpsum.paragraph

    factory :fake_review do
      body nil
    end
  end
end
