namespace :db do
  desc 'Fill database with sample data'
  task populate: :environment do
    make_posts
    puts ' '
  end
end

def make_posts
  50.times do
    title =   Faker::Lorem.sentence(5)
    content = Faker::Lorem.paragraph(100)
    Post.create!(title: title, content: content)
    print '|'
  end
end