FactoryBot.define do
  factory :micropost do
    content { Faker::Lorem.paragraph }
    user_id {}
  end
end
