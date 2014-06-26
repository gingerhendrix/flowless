class FieldValue
  class NumberValue < ::FieldValue
    include Mongoid::Document

    field :value, type: Float

  end
end