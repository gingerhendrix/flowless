module Eventable
  extend ActiveSupport::Concern

  included do
  end

  %w( new build create create! ).each do |method|
    bang = method.slice!('!')
    define_method("#{method}_event#{bang}") do |user, action, data|
      user.events.send "#{method}#{bang}", { entity: self, action: action, data: data }
    end
  end

  # Allows the creationg of the same event (entity and data) for a whole bunch
  # of users at the same time
  #
  # Not using create with a bang in order to avoid not creating the other events if an error is encountered
  #
  # @note This needs to be call in as a background task
  #
  # @return [ list_of_failed_events ] will be empty if everything was successfull
  def create_multiple_events_for(user_ids, action, data)
    failed_events = []
    user_ids.each do |user_id|
      e = Event.new(user_id: user_id, entity: self, action: action, data: data)
      failed_events << e unless e.save
    end
    failed_events
  end
end