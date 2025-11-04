FactoryBot.define do
  factory :automation_pipeline do
    association :author, factory: :user
    association :entity, factory: :issue
    association(:automation_rule)
    status { :scheduled }
  end
end
