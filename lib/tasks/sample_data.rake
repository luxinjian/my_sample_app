namespace :db do
  desc "Fill in database with sample data"
  task populate: :environment do
    make_user
  end
end

def make_user
  admin = User.create!(name: "Example User",
                      email: "example@railstutorial.org",
                      password: "foobar",
                      password_confirmation: "foobar")
  admin.toggle!(:admin)

  99.times do |n|
    name = Faker::Name.name
    email = "example-#{n+1}@railstutorial.org"
    User.create!(name: name,
                email: email,
                password: "foobar",
                password_confirmation: "foobar")
  end
end
