class GenerateRandomUserJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do something later
    user = User.new
    user.full_name = Faker::Name.full_name
    user.save!
    sleep 2
  end
end
