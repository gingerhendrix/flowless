class FieldValue
  class TextInputValue < ::FieldValue
    include Mongoid::Document

    field :value, type: String

  end
end