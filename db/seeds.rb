# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

User.find_or_create_by!(email: "admin@example.com") do |user|
  user.password = "password123"
  user.password_confirmation = "password123"
  user.role = :administrador
end

User.find_or_create_by!(email: "user@example.com") do |user|
  user.password = "password123"
  user.password_confirmation = "password123"
  user.role = :usuario
end

User.find_or_create_by!(email: "user2@example.com") do |user|
  user.password = "password123"
  user.password_confirmation = "password123"
  user.role = :usuario
end

User.find_or_create_by!(email: "user3@example.com") do |user|
  user.password = "password123"
  user.password_confirmation = "password123"
  user.role = :usuario
end


Vote.destroy_all
PollOption.destroy_all
Poll.destroy_all

usuario_users = User.where(role: :usuario)

poll_types = [ :unica_escolha ] * 5 + [ :multipla_escolha ] * 4
poll_types.shuffle!

expiring_times = [ 2.hours.from_now, 1.hour.from_now, 30.minutes.from_now ]

all_polls = []

usuario_users.each_with_index do |user, user_index|
  3.times do |i|
    poll_type = poll_types.pop
    is_expiring_poll = (i == 2)

    poll = user.polls.build(
      question: "Titulo genérico ##{user_index * 3 + i + 1}",
      poll_type: poll_type,
      status: :open,
      expires_at: is_expiring_poll ? expiring_times[user_index] : nil
    )

    num_options = rand(4..6)
    num_options.times do |j|
      poll.poll_options.build(text: "Opção genérica #{j + 1}")
    end

    if poll.multipla_escolha?
      poll.max_choices = rand(2..3)
    end

    poll.save!
    all_polls << poll
  end
end

usuario_users.each do |voter|
  polls_to_vote_on = Poll.where.not(user: voter).where(status: :open).sample(2)

  polls_to_vote_on.each do |poll|
    if poll.unica_escolha?
      option_to_vote = poll.poll_options.sample
      voter.votes.create!(poll_option: option_to_vote)
    elsif poll.multipla_escolha?
      num_votes = rand(1..poll.max_choices)
      options_to_vote = poll.poll_options.sample(num_votes)
      options_to_vote.each { |option| voter.votes.create!(poll_option: option) }
    end
  end
end
