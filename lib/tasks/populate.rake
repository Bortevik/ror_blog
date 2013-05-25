namespace :db do
  desc 'Fill database with sample data'
  task populate: :environment do
    make_posts
    make_users
    make_comments
    make_tags
    puts ' '
  end
end

def make_posts
  print 'Make posts'
  Post.delete_all
  50.times do
    title   = Faker::Lorem.sentence(5)
    content = Faker::Lorem.paragraph(100)
    Post.create!(title: title, content: content)
    print '.'
  end
  puts ' '
end

def make_users
  print 'Make users'
  User.delete_all
  50.times do |n|
    name  = "#{Faker::Name.name}#{n}"
    email = Faker::Internet.email
    User.create!(name: name,
                 email: email,
                 password: 'foobar',
                 password_confirmation: 'foobar')
    print'.'
  end
  puts ' '
end

def make_comments
  print 'Make comments'
  Comment.delete_all

  posts = Post.all
  users = User.all
  users << nil

  posts.each do |post|
    rand(10).times do
      comment = Comment.new(body: Faker::Lorem.paragraph(rand(10) + 1),
                            post_id: post.id)
      comment.user_id = users.sample.try(:id)
      comment.save!
      print '.'
    end
  end
  puts ' '
end

def make_tags
  print 'Make tags'
  Tag.delete_all
  Taggin.delete_all

  20.times do |n|
    Tag.create!(name: "#{Faker::Lorem.word}#{n}")
  end
  posts = Post.all
  tags = Tag.all

  posts.each do |post|
    3.times do
      tag = tags.sample
      post.tags << tag unless post.tags.include?(tag)
    end
    print '.'
  end

  tags.each do |tag|
    tag.update_attributes(posts_count: tag.posts.count)
  end
  puts ' '
end
