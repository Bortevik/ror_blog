namespace :db do
  desc 'Fill database with sample data'
  task populate: :environment do
    make_posts
    make_users
    puts ' '
  end
end

def make_posts
  50.times do
    title   = Faker::Lorem.sentence(5)
    content = Faker::Lorem.paragraph(100)
    Post.create!(title: title, content: content)
    print '|'
  end
end

def make_users
  50.times do
    name  = Faker::Name.name
    email = Faker::Internet.email
    User.create!(name: name,
                 email: email,
                 password: 'foobar',
                 password_confirmation: 'foobar')
    print'.'
  end
end