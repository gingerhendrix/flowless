class FieldValue
  class DatetimeValue < ::FieldValue
    include Mongoid::Document

    field :value, type: DateTime

  end
end