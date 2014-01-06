class FieldValue
  class CheckboxValue < ::FieldValue
    include Mongoid::Document

    field :value, type: String

  end
end