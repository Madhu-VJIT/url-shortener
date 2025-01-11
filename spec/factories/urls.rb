FactoryBot.define do
    factory :url do
      long_url { "https://example.com" }
      sequence(:short_url) { |n| "abc#{n}" }
    end
end