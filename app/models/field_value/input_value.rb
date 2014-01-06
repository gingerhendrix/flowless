class FieldValue
  class InputValue < ::FieldValue
    include Mongoid::Document

    field :value, type: String

  end
end