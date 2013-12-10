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
end