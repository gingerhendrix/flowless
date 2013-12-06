class FieldValue
  class TextAreaValue < ::FieldValue
    include Mongoid::Document

    field :value, type: String

  end
end