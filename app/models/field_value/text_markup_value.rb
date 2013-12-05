class FieldValue
  class TextMarkupValue < ::FieldValue
    include Mongoid::Document

    field :value, type: String

  end
end