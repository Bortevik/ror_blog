namespace :db do
  desc 'Fill database with sample data'
  task populate: :environment do
    make_posts
    make_users
    make_comments
    puts ' '
  end
end

def make_posts
  Post.delete_all
  50.times do
    title   = Faker::Lorem.sentence(5)
    content = Faker::Lorem.paragraph(100)
    Post.create!(title: title, content: content)
    print '|'
  end
end

def make_users
  User.delete_all
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

def make_comments
  Comment.delete_all
  posts = Post.all
  users = User.all
  users << nil
  posts.each do |post|
    print '#'
    rand(10).times do
      comment = Comment.new(body: Faker::Lorem.paragraph(rand(10) + 1),
                            post_id: post.id)
      comment.user_id = users.sample.try(:id)
      comment.save!
      print '.'
    end
  end
end
