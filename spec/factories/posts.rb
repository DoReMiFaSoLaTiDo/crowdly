require 'ffaker'

FactoryGirl.define do
  factory :post do
    user
    title { FFaker::Lorem.word }
    body { FFaker::HipsterIpsum.paragraph }

  end
end
