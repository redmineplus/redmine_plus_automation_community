FactoryBot.define do
  factory :automation_rule do
    sequence(:name) { |n| "Automation Rule #{n}" }
    description { "Description of #{name}" }
    association :author, factory: :user
    enabled { true }
    is_for_all { true }
  end
end
