class FieldValue
  class TextareaValue < ::FieldValue
    include Mongoid::Document

    field :value, type: String

  end
end