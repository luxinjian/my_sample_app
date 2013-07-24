FactoryGirl.define do
  factory :user do
    sequence(:name) { |n| "name-#{n}" }
    sequence(:email) { |n| "name-#{n}@example.com" }
    password      "foobar"
    password_confirmation "foobar"

    factory :admin do
      admin = true
    end
  end
end
