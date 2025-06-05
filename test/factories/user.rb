FactoryBot.define do
  factory :user do
    name{Faker::Name.name}
    email{Faker::Internet.email}
    password_digest{User.digest("password")}
    admin{true}
    activated{true}
    activated_at{Time.zone.now}
  end

  trait :non_admin do
    admin{false}
  end

  trait :has_microposts do
    transient do
      total_post{1}
    end

    after(:create) do |user, evaluator|
      evaluator.total_post.times do |idx|
        user.microposts << create(:micropost, user_id: user.id)
      end
    end
  end
end
