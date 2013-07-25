namespace :db do
  desc "Fill in database with sample data"
  task populate: :environment do
    make_users
    make_microposts
    make_relationships
  end
end

def make_users
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

def make_microposts
  User.all(limit: 6).each do |u|
    50.times do
      content = Faker::Lorem.sentence(5)
      u.microposts.create!(content: content)
    end
  end
end

def make_relationships
  user = User.first
  User.all[1, 50].each do |u|
    u.follow!(user)
    user.follow!(u)
  end
end
