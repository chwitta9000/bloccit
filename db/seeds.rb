require 'faker'

# Create 15 topics first
topics = []
2.times do
  topics << Topic.create(
    name: Faker::Lorem.words(rand(3..10)).join(" "),
    description: Faker::Lorem.paragraph(rand(1..4)))
end

rand(1..2).times do
  password = Faker::Lorem.characters(10)
  u = User.new(
    name: Faker::Name.name,
    email: Faker::Internet.email,
    password: password,
    password_confirmation: password)
  u.skip_confirmation!
  u.save

# Note that we use User.new and then u.save instead of User.create
# This allows us to use skip_confirmation!

  rand(1..2).times do
    topic = topics.first
    p = u.posts.create(
      topic: topic,
      title: Faker::Lorem.words(rand(1..10)).join(" "),
      body: Faker::Lorem.paragraphs(rand(1..4)).join("\n"))
      p.update_attribute(:created_at, Time.now - rand(600..31536000)) 

      p.update_rank
      topics.rotate!
  end
end

u = User.new(
  name: 'Admin User',
  email: 'admin@example.com',
  password: 'changeme',
  password_confirmation: 'changeme')
u.skip_confirmation!
u.save
u.update_attribute(:role, 'admin')

u = User.new(
  name: 'Moderator User',
  email: 'moderator@example.com',
  password: 'changeme',
  password_confirmation: 'changeme')
u.skip_confirmation!
u.save
u.update_attribute(:role, 'moderator')

u = User.new(
  name: 'Member User',
  email: 'member@example.com',
  password: 'changeme',
  password_confirmation: 'changeme')
u.skip_confirmation!
u.save
u.update_attribute(:role, 'member')

post_count = Post.count
User.all.each do |user|
  rand(1..5).times do
    p = Post.find(rand(1..post_count))
    c = user.comments.create(
      body: Faker::Lorem.paragraphs(rand(1..2)).join("\n"),
      post: p)
    c.update_attribute(:created_at, Time.now - rand(600..31536000))
  end
end

puts "Seed finished"
puts "#{User.count} users created"
puts "#{Post.count} posts created"
puts "#{Comment.count} comments created"